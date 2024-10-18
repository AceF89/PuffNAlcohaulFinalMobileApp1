import 'dart:async';
import 'package:alcoholdeliver/apis/auth_api/auth_api.dart';
import 'package:alcoholdeliver/apis/google_map_api/google_map_api.dart';
import 'package:alcoholdeliver/apis/place_api/place_api.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/model/city_state_info.dart';
import 'package:alcoholdeliver/model/google/g_place_details.dart';
import 'package:alcoholdeliver/model/google/g_places.dart';
import 'package:alcoholdeliver/services/connectivity_service.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alcoholdeliver/providers/default_change_notifier.dart';

final AutoDisposeChangeNotifierProvider<SignupProvider> signupProvider =
    ChangeNotifierProvider.autoDispose((ref) => SignupProvider());

class SignupProvider extends DefaultChangeNotifier {
  bool passwordObscureText = true;
  bool confirmPasswordObscureText = true;
  final AuthApi _authApi = AuthApi.instance;
  final PlaceApi _placeApi = PlaceApi.instance;
  List<GPlaces> searchedPlaces = [];
  bool isSearchLoading = false;
  GPlaceDetails? placeDetails;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GoogleMapApi _googleMapApi = GoogleMapApi.instance;

  Timer? _debounce;
  bool agreeTermCondition = false;
  String selectedUserRole = '2';
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController apartmentController = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController zipcodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  GPlaces? selectedPlace;
  String displayAddress = '';

  DateTime? selectedDob;
  bool showDobDateError = false;

  CityStateInfo? cityStateData;
  TextEditingController selectedStateController = TextEditingController();
  TextEditingController selectedCityController = TextEditingController();

  SignupProvider();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    mobileNumberController.dispose();
    address2Controller.dispose();
    address1Controller.dispose();
    zipcodeController.dispose();
    cityController.dispose();
    stateController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onChangeSearch(String? input) {
    if (input == null) return;
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      autocompletePlaces(input: input);
    });
  }

  void onChangeZipcode(String data) {
    if (data.trim().length >= 5) {
      getCityStateByZipcode();
    }
  }

  bool isValid() {
    if (selectedDob == null) {
      showDobDateError = true;
      return false;
    }
    return true;
  }

  bool is21YearsOld(DateTime dob) {
    DateTime now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age >= 21;
  }

  void onChangeDobDate({required DateTime n}) {
    selectedDob = n;
    showDobDateError = false;
    notify();
  }

  void handleOnChangeRole(String n) {
    selectedUserRole = n;
    notify();
  }

  void handleTermConditionToggle(bool? value) {
    if (value == null) return;
    agreeTermCondition = value;
    notify();
  }

  void togglePasswordObscureText() {
    passwordObscureText = !passwordObscureText;
    notify();
  }

  void onSelectSearchLocation(GPlaces place) async {
    searchedPlaces.clear();
    selectedPlace = place;

    address1Controller.text = place.structuredFormatting?.mainText ?? '';
    debugPrint("place desc: ${place.description}");
    displayAddress = place.description ?? '';
    notify();

    placeDetails = await getPlacesLatLng(placeId: selectedPlace?.placeId);
    if (placeDetails == null) {
      notify();
      return;
    }

    zipcodeController.text = placeDetails?.postalCode ?? '';
    getCityStateByZipcode();

    notify();
  }

  void toggleSearchLoading(bool n) {
    isSearchLoading = n;
    notify();
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

  Future<bool> signupUser(BuildContext context) async {
    if (!isValid()) return false;
    if (!is21YearsOld(selectedDob!)) {
      context.showFailureSnackBar('User must be 21 years old');
      return false;
    }
    if (!agreeTermCondition) return false;
    if (!(formKey.currentState?.validate() ?? false)) return false;

    // GPlaceDetails? placeDetails = await getPlacesLatLng(placeId: selectedPlace?.placeId);
    if (placeDetails == null) return false;

    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result = await _authApi.userSignup(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        mobile: mobileNumberController.text.trim(),
        roleId: 2,
        // apartment: apartmentController.text.trim(),
        address: address1Controller.text.trim(),
        address2: address2Controller.text.trim(),
        googleAddress: displayAddress,
        cityId: cityStateData?.city?.id ?? 0,
        dob: selectedDob!,
        latitude: placeDetails?.latLng.latitude as num,
        longitude: placeDetails?.latLng.longitude as num,
        storeId: 0,
        zipCode: zipcodeController.text.trim(),
      );

      return result.when(
        (value) async {
          Loader.dismiss(context);
          preferences.userProfile = value;
          context.showSuccessSnackBar('Signup successful');
          notify();
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
}
