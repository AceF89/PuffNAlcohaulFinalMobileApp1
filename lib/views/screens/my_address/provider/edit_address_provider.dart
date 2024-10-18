import 'dart:async';
import 'package:alcoholdeliver/apis/google_map_api/google_map_api.dart';
import 'package:alcoholdeliver/apis/place_api/place_api.dart';
import 'package:alcoholdeliver/apis/user_api/user_api.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/model/city_state_info.dart';
import 'package:alcoholdeliver/model/google/g_place_details.dart';
import 'package:alcoholdeliver/model/google/g_places.dart';
import 'package:alcoholdeliver/model/user_address.dart';
import 'package:alcoholdeliver/providers/default_change_notifier.dart';
import 'package:alcoholdeliver/services/connectivity_service.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ChangeNotifierProvider<EditAddressProvider> editAddressProvider =
    ChangeNotifierProvider((ref) => EditAddressProvider());

class EditAddressProvider extends DefaultChangeNotifier {
  final UserApi _userApi = UserApi.instance;
  final PlaceApi _placeApi = PlaceApi.instance;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UserAddress? oldAddress;
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController zipcodeController = TextEditingController();
  CityStateInfo? cityStateData;
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  String displayAddress = '';

  double? newLatitude;
  double? newLongitude;

  Timer? _debounce;
  List<GPlaces> searchedPlaces = [];
  bool isSearchLoading = false;
  GPlaceDetails? placeDetails;
  GPlaces? selectedPlace;
  final GoogleMapApi _googleMapApi = GoogleMapApi.instance;

  EditAddressProvider();

  cleanAddresDetailsPage() {
    clientNameController.clear();
    addressController.clear();
    address2Controller.clear();
    phoneNumberController.clear();
    zipcodeController.clear();
    cityController.clear();
    stateController.clear();
    displayAddress = '';
    newLatitude = null;
    newLongitude = null;
    searchedPlaces.clear();
    selectedPlace = null;
    placeDetails = null;
    cityStateData = null;
    notify();
  }

  void setSetupOldAddress(UserAddress oldInfo, BuildContext context) async {
    cleanAddresDetailsPage();
    oldAddress = oldInfo;
    clientNameController.text = oldInfo.name ?? '';
    address2Controller.text = oldInfo.address2 ?? '';
    addressController.text = oldInfo.address ?? '';
    phoneNumberController.text = oldInfo.phoneNumber ?? '';
    zipcodeController.text = oldInfo.zipcode ?? '';
    cityController.text = oldInfo.cityName ?? '';
    stateController.text = oldInfo.stateName ?? '';
    zipcodeController.text = oldInfo.zipcode ?? '';
    displayAddress = oldInfo.googleAddress ?? '';
    notify();
  }

  // void onChangeZipcode(String data) {
  //   if (data.trim().length >= 5) {
  //     getCityStateByZipcode();
  //   }
  // }

  void toggleSearchLoading(bool n) {
    isSearchLoading = n;
    notify();
  }

  void onChangeSearch(String? input) {
    if (input == null) return;
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(seconds: 1), () {
      autocompletePlaces(input: input);
    });
  }

  void onSelectSearchLocation(GPlaces place) async {
    searchedPlaces.clear();
    selectedPlace = place;
    addressController.text = place.structuredFormatting?.mainText ?? '';
    displayAddress = place.description ?? '';

    placeDetails = await getPlacesLatLng(placeId: selectedPlace?.placeId);
    if (placeDetails == null) {
      notify();
      return;
    }
    newLatitude = placeDetails?.geometry?.location?.lat;
    newLongitude = placeDetails?.geometry?.location?.lng;

    zipcodeController.text = placeDetails?.postalCode ?? '';
    getCityStateByZipcode();

    notify();
  }

  Future<void> autocompletePlaces({required String input}) async {
    final context = kNavigatorKey.currentState?.context;

    if (await ConnectivityService.isConnected) {
      searchedPlaces.clear();
      toggleSearchLoading(true);

      var result = await _googleMapApi.autocompletePlaces(input: input);

      return result.when(
        (value) async {
          searchedPlaces = value;
          toggleSearchLoading(false);
        },
        (error) => toggleSearchLoading(false),
      );
    } else {
      // ignore: use_build_context_synchronously
      if (context != null) context.showFailureSnackBar(kNoInternet);
    }
  }

  Future<GPlaceDetails?> getPlacesLatLng({required String? placeId}) async {
    if (placeId == null) return null;
    final context = kNavigatorKey.currentState?.context;
    if (context == null) return null;

    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result =
          await _googleMapApi.getPlacesDetailsByPlaceId(placeId: placeId);

      return result.when(
        (value) async {
          // ignore: use_build_context_synchronously
          Loader.dismiss(context);
          return value;
        },
        (error) {
          context.showFailureSnackBar(error);
          // ignore: use_build_context_synchronously
          Loader.dismiss(context);
          return null;
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
      return null;
    }
  }

  Future<void> getCityStateByZipcode() async {
    BuildContext? context = kNavigatorKey.currentState?.context;
    if (context == null) return;

    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result =
          await _placeApi.getCityStateByZipcode(zipcodeController.text);

      return result.when(
        (value) async {
          cityStateData = value;
          if (cityStateData?.city != null)
            cityController.text = cityStateData?.city?.name ?? '';
          if (cityStateData?.state != null)
            stateController.text = cityStateData?.state?.name ?? '';
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

  Future<void> getMe(BuildContext context) async {
    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result = await _userApi.getMe();

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

  Future<bool> saveAddress(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) return false;
    if (cityController.text.isEmpty && cityStateData?.city == null) {
      context.showFailureSnackBar('City is Mandatory Field');
      return false;
    }

    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      final address = UserAddress(
        id: oldAddress?.id,
        name: clientNameController.text.trim(),
        address: addressController.text.trim(),
        cityId: cityStateData?.city?.id ?? oldAddress?.cityId,
        zipcode: zipcodeController.text.trim(),
        apartment: address2Controller.text.trim(),
        phoneNumber: phoneNumberController.text.trim(),
        isDefault: oldAddress?.isDefault,
        userId: preferences.getUserProfile()?.id,
        latitude: newLatitude ?? oldAddress?.latitude,
        longitude: newLongitude ?? oldAddress?.longitude,
        googleAddress: displayAddress,
      );

      var result = await _userApi.addNewAddress(address: address);

      return result.when(
        (value) async {
          notify();
          Loader.dismiss(context);
          await getMe(context);
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

  String getDisplayAddress(
      String address, String googleAddress, String address2) {
    // Find the index of the address substring in googleAddress
    int index = googleAddress.indexOf(address);

    // If address is found in googleAddress
    if (index != -1) {
      // Split googleAddress into two parts: before and after the address substring
      String beforeAddress = googleAddress.substring(0, index + address.length);
      String afterAddress = googleAddress.substring(index + address.length);

      // Insert address2 after the address substring
      return beforeAddress + ', ' + address2 + afterAddress;
    }

    // If address is not found, return the original googleAddress
    return googleAddress;
  }
}
