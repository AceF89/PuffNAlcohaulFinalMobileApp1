import 'dart:io';
import 'package:alcoholdeliver/apis/order_api/order_api.dart';
import 'package:alcoholdeliver/apis/product_api/product_api.dart';
import 'package:alcoholdeliver/apis/store_api/store_api.dart';
import 'package:alcoholdeliver/apis/user_api/user_api.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/core/utils/enums.dart';
import 'package:alcoholdeliver/core/utils/file_utils.dart';
import 'package:alcoholdeliver/model/appsettings_model.dart';
import 'package:alcoholdeliver/model/cart.dart';
import 'package:alcoholdeliver/model/charge_card_res.dart';
import 'package:alcoholdeliver/model/file_upload_response.dart';
import 'package:alcoholdeliver/model/saved_cards.dart';
import 'package:alcoholdeliver/model/stripe_card_res.dart';
import 'package:alcoholdeliver/providers/default_change_notifier.dart';
import 'package:alcoholdeliver/services/connectivity_service.dart';
import 'package:alcoholdeliver/views/dialog/upload_file_dialog.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TipPercentage { ten, fifteen, twenty, twentyFive, custom, none }

enum DeliveryMethod { delivery, pickup }

enum DeliveryDateTime { asSoonAsPossible, dateTime }

// ignore: constant_identifier_names
const SERVICE_FEE = 3.99;
// ignore: constant_identifier_names
const SERVICE_FEE_THRESOLD = 35;

final AutoDisposeChangeNotifierProvider<CheckoutProvider> checkoutProvider =
    ChangeNotifierProvider.autoDispose((ref) => CheckoutProvider());

class CheckoutProvider extends DefaultChangeNotifier {
  final UserApi _userApi = UserApi.instance;
  final ProductApi _api = ProductApi.instance;
  final OrderApi _orderApi = OrderApi.instance;
  final StoreApi _storeApi = StoreApi.instance;

  Cart? cartData;
  AppSettingModel? appSettings;
  bool isUserWithinDeliveryRadius = false;
  TipPercentage? selectedTip = TipPercentage.twenty;
  DeliveryMethod deliveryMethod = DeliveryMethod.delivery;
  TextEditingController tipController = TextEditingController();
  DeliveryDateTime deliveryDateTime = DeliveryDateTime.asSoonAsPossible;
  final TextEditingController loyaltyController = TextEditingController();
  num loyaltyPoints = 0;

  DateTime? selectedDeliveryDate;
  bool showDeliveryDateError = false;

  TimeOfDay? selectedDeliveryTime;
  bool showDeliveryTimeError = false;

  File? frontLicense;
  File? backLicense;

  final GlobalKey<FormState> paymentMethodFormKey = GlobalKey<FormState>();
  final TextEditingController cardHolderName = TextEditingController();
  final TextEditingController cardNumber = TextEditingController();
  final TextEditingController validUntil = TextEditingController();
  final TextEditingController securityCode = TextEditingController();
  final TextEditingController emailAddress = TextEditingController();
  bool isAcceptedTerm = false;
  bool isAcceptedDefaultPayment = false;

  List<SavedCards> savedCards = [];
  bool isLoadingSavedCards = true;
  SavedCards? selectedSavedCard;

  CheckoutProvider();

  String? get frontDLUrl => preferences.getUserProfile()?.fullFrontLicenseFileUrl;

  String? get backDLUrl => preferences.getUserProfile()?.fullBackLicenseFileUrl;

  num get serviceFee {
    if (deliveryMethod == DeliveryMethod.pickup) return 0;
    return subTotal > SERVICE_FEE_THRESOLD ? 0 : SERVICE_FEE;
  }

  num get taxes => num.parse((subTotal * 0.0825).toStringAsFixed(2));

  num get subTotal {
    List<OrderItem> cartItems = cartData?.orderItems ?? [];
    final total = cartItems.fold<double>(
      0,
      (pv, e) => pv + ((e.price ?? 1) * (e.quantity ?? 1)),
    );

    return num.parse(total.toStringAsFixed(2));
  }

  bool get isDataAvailable {
    if (cartData?.orderItems?.isNotEmpty ?? false) return true;
    return false;
  }

  String? get awayFromFreeService {
    if (subTotal > 35) return 'CONGRATS!! YOUR SERVICE FEE IS NOW FREE!';
    if (subTotal > 10 && subTotal < 35) {
      final sum = (35 - subTotal).toStringAsFixed(2);
      return 'You are just \$$sum away from free service';
    }
    return null;
  }

  num get tipPercentage {
    if (selectedTip == TipPercentage.ten) return 10;
    if (selectedTip == TipPercentage.fifteen) return 15;
    if (selectedTip == TipPercentage.twenty) return 20;
    if (selectedTip == TipPercentage.twentyFive) return 25;
    if (selectedTip == TipPercentage.custom) {
      String text = tipController.text.trim();
      if (text.isEmpty) return 0;
      if (text.startsWith('.')) text = '0.';
      return num.parse(text);
    }

    return 0;
  }

  num get driversTip {
    num driversTip = 0;
    if (selectedTip != TipPercentage.custom) {
      driversTip = subTotal * tipPercentage / 100;
    } else {
      driversTip = tipPercentage;
    }
    return num.parse(driversTip.toStringAsFixed(2));
  }

  num get total => num.parse((subTotal + driversTip + taxes + serviceFee).toStringAsFixed(2));

  num get totalWithLoyalty =>
      num.parse((subTotal + driversTip + taxes + serviceFee - (loyaltyPoints / 100)).toStringAsFixed(2));

  void onChangeValidUntil(String value) {
    if (value.length == 2 && !value.contains('/')) {
      validUntil.text = '$value/';
    }
  }

  void onChangeDeliveryDate({required DateTime n}) {
    selectedDeliveryDate = n;
    showDeliveryDateError = false;
    notify();
  }

  void toggleSaveCardLoading(bool state) {
    isLoadingSavedCards = state;
    notify();
  }

  void onChangeDeliveryTime(TimeOfDay n) {
    selectedDeliveryTime = n;
    showDeliveryTimeError = false;
    notify();
  }

  void onChangeCard(SavedCards nCard) {
    if (selectedSavedCard?.id == nCard.id) {
      selectedSavedCard = null;
    } else {
      selectedSavedCard = nCard;
    }

    notify();
  }

  void onChangeLoyaltyPoints(num n) {
    loyaltyPoints = n;
    if (n == 0) loyaltyController.clear();
    notify();
  }

  void onSelectTip(TipPercentage method) {
    if (method != TipPercentage.custom) {
      tipController.clear();
    }
    selectedTip = method;
    notify();
  }

  void removeCards(SavedCards card) {
    savedCards.removeWhere((e) => e.id == card.id);
    notify();
  }

  void removeItem(OrderItem orderItem) {
    List<OrderItem> oldItems = cartData?.orderItems ?? [];
    oldItems.removeWhere((e) => e.id == orderItem.id);
    cartData?.copyWith(orderItems: oldItems);
    notify();
  }

  void updateQuantity(OrderItem product, num quantity) {
    List<OrderItem> oldItems = cartData?.orderItems ?? [];

    final index = oldItems.indexWhere((e) => e.id == product.id);
    if (index == -1) return;

    oldItems[index] = oldItems[index].copyWith(quantity: quantity);
    cartData?.copyWith(orderItems: oldItems);

    notify();
  }

  void changeDeliveryMethod(DeliveryMethod m) {
    deliveryMethod = m;
    notify();
  }

  void changeDeliveryDateTime(DeliveryDateTime m) {
    deliveryDateTime = m;
    notify();
  }

  void toggleTermandCondition(bool? value) {
    if (value == null) return;
    isAcceptedTerm = value;
    notify();
  }

  void toggleDefaultPayment(bool m) {
    isAcceptedDefaultPayment = m;
    notify();
  }

  void clear() {
    cartData = null;
    selectedTip = TipPercentage.twenty;
    deliveryMethod = DeliveryMethod.delivery;
    deliveryDateTime = DeliveryDateTime.asSoonAsPossible;
    loyaltyController.clear();
    loyaltyPoints = 0;

    selectedDeliveryDate = null;
    showDeliveryDateError = false;

    selectedDeliveryTime = null;
    showDeliveryTimeError = false;

    savedCards.clear();
    isLoadingSavedCards = true;
    selectedSavedCard = null;

    frontLicense = null;
    backLicense = null;
    notify();
  }

  Future<void> checkUserIsWithinDeliveryRadius(BuildContext context) async {
    Loader.show(context);

    final result = await _storeApi.getNearbyStore(
      filters: 'MY',
      radius: 7,
      storeId: preferences.getUserProfile()?.stateId ?? 1,
    );

    return result.when(
      (value) async {
        isUserWithinDeliveryRadius = value;
        if (!isUserWithinDeliveryRadius) changeDeliveryMethod(DeliveryMethod.pickup);
        Loader.dismiss(context);
        notify();
      },
      (error) {
        isUserWithinDeliveryRadius = false;
        changeDeliveryMethod(DeliveryMethod.pickup);
        Loader.dismiss(context);
      },
    );
  }

  Future<void> onSelectImage(BuildContext context, String type) async {
    var file = await UploadFileDialog.show(context, useGallery: Platform.isIOS);
    if (file == null) return;

    if (file.size <= kMaximumFileSize) {
      if (type == 'FRONT') {
        frontLicense = file;
        // ignore: use_build_context_synchronously
        final res = await uploadFile(context, file);
        // ignore: use_build_context_synchronously
        await saveDrivingLicence(context, DrivingLicense.front, res?.id ?? 0);
      }

      if (type == 'BACK') {
        backLicense = file;
        // ignore: use_build_context_synchronously
        final res = await uploadFile(context, file);
        // ignore: use_build_context_synchronously
        await saveDrivingLicence(context, DrivingLicense.back, res?.id ?? 0);
      }

      notify();
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar('You can upload maximum file size upto $kMaximumFileSize MB');
    }
  }

  Future<FileUploadResponse?> uploadFile(BuildContext context, File file) async {
    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result = await _userApi.uploadFile(file);

      return result.when(
        (value) async {
          Loader.dismiss(context);
          return value;
        },
        (error) {
          Loader.dismiss(context);
          context.showFailureSnackBar(error);
          return null;
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
      return null;
    }
  }

  Future<Cart?> getCart(BuildContext context) async {
    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result = await _api.getCart();

      return result.when(
        (value) async {
          Loader.dismiss(context);
          cartData = value;
          notify();
          return value;
        },
        (error) {
          Loader.dismiss(context);
          context.showFailureSnackBar(error);
          return null;
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
      return null;
    }
  }

  Future<bool> preCheckout(BuildContext context) async {
    if (await ConnectivityService.isConnected) {
      if (deliveryMethod == DeliveryMethod.delivery) {
        final user = preferences.getUserProfile();

        if (user?.frontLicenseFileUrl == null && frontLicense == null) {
          // ignore: use_build_context_synchronously
          context.showFailureSnackBar('Please select Front License');
          return false;
        }
        if (user?.backLicenseFileUrl == null && backLicense == null) {
          // ignore: use_build_context_synchronously
          context.showFailureSnackBar('Please select Back License');
          return false;
        }
      }

      if (deliveryDateTime == DeliveryDateTime.dateTime) {
        if (selectedDeliveryDate == null) {
          // ignore: use_build_context_synchronously
          context.showFailureSnackBar('Please select Delivery Date');
          return false;
        }
        if (selectedDeliveryTime == null) {
          // ignore: use_build_context_synchronously
          context.showFailureSnackBar('Please select Delivery Time');
          return false;
        }
      }

      DateTime datetime = DateTime.now();
      if (deliveryDateTime == DeliveryDateTime.dateTime) {
        datetime = DateTime(
          selectedDeliveryDate!.year,
          selectedDeliveryDate!.month,
          selectedDeliveryDate!.day,
          selectedDeliveryTime!.hour,
          selectedDeliveryTime!.minute,
        );
      }

      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result = await _orderApi.preCheckout(
        tip: driversTip,
        tipscheduleDate: datetime,
        orderType: deliveryMethod == DeliveryMethod.delivery ? 'Delivery' : 'PickUp',
      );

      return result.when(
        (value) async {
          await getMe(context);
          // ignore: use_build_context_synchronously
          Loader.dismiss(context);
          return true;
        },
        (error) {
          Loader.dismiss(context);
          context.showFailureSnackBar(error);
          return false;
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
      return false;
    }
  }

  Future<void> saveDrivingLicence(BuildContext context, DrivingLicense type, num id) async {
    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result = await _userApi.saveDrivingLicence(licenceId: id, type: type);

      return result.when(
        (value) async {
          final oldUser = preferences.getUserProfile();
          final updatedProfile = value.copyWith(token: oldUser?.token);
          preferences.userProfile = updatedProfile;
          notify();
          Loader.dismiss(context);
        },
        (error) {
          Loader.dismiss(context);
          context.showFailureSnackBar(error);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
    }
  }

  Future<bool> getAllSavedStripeCard(BuildContext context) async {
    if (await ConnectivityService.isConnected) {
      toggleSaveCardLoading(true);

      var result = await _api.getAllSavedStripeCard();

      return result.when(
        (value) async {
          savedCards = value;
          toggleSaveCardLoading(false);
          return true;
        },
        (error) {
          toggleSaveCardLoading(false);
          context.showFailureSnackBar(error);
          return false;
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
      return true;
    }
  }

  Future<StripeCardRes?> getTokenFromStripeCard(BuildContext context) async {
    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result = await _api.getTokenFromStripeCard(
        cardNumber: cardNumber.text.trim(),
        expiryMonth: validUntil.text.trim().split('/')[0],
        expiryYear: '20${validUntil.text.trim().split('/')[1]}',
        cvv: securityCode.text.trim(),
        token: appSettings!.value!
      );

      return result.when(
        (value) async {
          Loader.dismiss(context);
          return value;
        },
        (error) {
          Loader.dismiss(context);
          context.showFailureSnackBar(error);
          return null;
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
      return null;
    }
  }

  Future getAllAppSettings(BuildContext context) async {
    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result = await _api.getAllAppSettings();

      return result.when(
        (value) async {
          appSettings = value.first;
          notify();
          Loader.dismiss(context);
          // return value;
        },
        (error) {
          Loader.dismiss(context);
          context.showFailureSnackBar(error);
          return null;
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
      return null;
    }
  }

  Future<bool> saveCardTokenToStripe(
    BuildContext context,
    String cardToken,
  ) async {
    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result = await _api.saveCardTokenToStripe(cardToken: cardToken);

      return result.when(
        (value) async {
          Loader.dismiss(context);
          return true;
        },
        (error) {
          Loader.dismiss(context);
          context.showFailureSnackBar(error);
          return false;
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
      return false;
    }
  }

  Future<void> deleteCard(BuildContext context, SavedCards card) async {
    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);
      var result = await _api.deleteCardFromStripe(cardToken: card.id ?? '');

      return result.when(
        (value) async {
          removeCards(card);
          Loader.dismiss(context);
        },
        (error) {
          context.showFailureSnackBar(error);
          Loader.dismiss(context);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
    }
  }

  Future<void> applyLoyaltyPoints(BuildContext context) async {
    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);
      var result = await _orderApi.applyLoyaltyPoints(orderId: cartData?.id ?? 0, points: loyaltyPoints);

      return result.when(
        (value) async {
          Loader.dismiss(context);
        },
        (error) {
          context.showFailureSnackBar(error);
          Loader.dismiss(context);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
    }
  }

  Future<void> getMe(BuildContext context) async {
    if (await ConnectivityService.isConnected) {
      var result = await _userApi.getMe();

      return result.when(
        (value) async {
          final oldUser = preferences.getUserProfile();
          final updatedProfile = value.copyWith(token: oldUser?.token);
          preferences.userProfile = updatedProfile;
          notify();
        },
        (error) => context.showFailureSnackBar(error),
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
    }
  }

  Future<ChargeCardRes?> chargeCard(BuildContext context, String cardToken) async {
    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      await _api.checkout();

      var result = await _api.chargeCard(
        cardId: cardToken,
        orderId: cartData?.id ?? 0,
      );

      return result.when(
        (value) async {
          Loader.dismiss(context);
          return value;
        },
        (error) {
          Loader.dismiss(context);
          context.showFailureSnackBar(error);
          return null;
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
      return null;
    }
  }
}
