import 'dart:async';
import 'package:alcoholdeliver/apis/google_map_api/google_map_api.dart';
import 'package:alcoholdeliver/apis/place_api/place_api.dart';
import 'package:alcoholdeliver/apis/user_api/user_api.dart';
import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/model/city_state_info.dart';
import 'package:alcoholdeliver/model/google/g_custom_places.dart';
import 'package:alcoholdeliver/model/google/g_place_details.dart';
import 'package:alcoholdeliver/model/google/g_places.dart';
import 'package:alcoholdeliver/model/user_address.dart';
import 'package:alcoholdeliver/providers/default_change_notifier.dart';
import 'package:alcoholdeliver/services/connectivity_service.dart';
import 'package:alcoholdeliver/services/geo_locator_service.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final ChangeNotifierProvider<ConfirmDeliveryProvider> confirmDeliveryProvider =
    ChangeNotifierProvider((ref) => ConfirmDeliveryProvider());

class ConfirmDeliveryProvider extends DefaultChangeNotifier {
  LatLng? currentPosition;
  GCustomPlaces? currentAddress;
  final Set<Marker> markers = {};
  GoogleMapController? gController;
  final PlaceApi _placeApi = PlaceApi.instance;
  BitmapDescriptor _customMarker = BitmapDescriptor.defaultMarker;

  Timer? _debounce;
  GPlaces? selectedPlaces;
  bool isSearchLoading = false;
  List<GPlaces> searchedPlaces = [];
  final GoogleMapApi _googleMapApi = GoogleMapApi.instance;
  final TextEditingController searchController = TextEditingController();

  final UserApi _userApi = UserApi.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController zipcodeController = TextEditingController();
  CityStateInfo? cityStateData;
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  GPlaceDetails? placeDetails;
  String displayAddress = '';

  ConfirmDeliveryProvider() {
    _loadCustomMarker();
  }

  @override
  void dispose() {
    super.dispose();
    gController?.dispose();
    _debounce?.cancel();
  }

  /// Call this method to clean Dispose
  void clean() {
    currentPosition = null;
    currentAddress = null;
    markers.clear();
    gController?.dispose();
    _debounce?.cancel();
  }

  void cleanAddresDetailsPage() {
    clientNameController.clear();
    addressController.clear();
    displayAddress = '';
    address2Controller.clear();
    phoneNumberController.clear();
    zipcodeController.clear();
    cityStateData = null;
    cityController.clear();
    stateController.clear();
  }

  bool get isMarkerEmpty => markers.isEmpty;

  void onChangeSearch(String? input) {
    if (input == null) return;
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(seconds: 1), () {
      autocompletePlaces(input: input);
    });
  }

  void onChangeZipcode(String data) {
    if (data.trim().length >= 5) {
      getCityStateByZipcode();
    }
  }

  void onSelectSearchLocation(GPlaces place) async {
    selectedPlaces = place;
    searchedPlaces.clear();
    searchController.clear();

    final position = await getPlacesLatLng(placeId: selectedPlaces?.placeId);
    if (position == null) return;

    _setupLocationNAddress(GCustomPlaces(
      position: position,
      address: place.description,
      placeId: place.placeId,
    ));

    notify();
  }

  Future<void> onSelectSearchLocationAddressDetails(GPlaces place) async {
    selectedPlaces = place;
    searchedPlaces.clear();
    searchController.clear();
    addressController.text = place.structuredFormatting?.mainText ?? '';
    displayAddress = place.description ?? '';

    placeDetails = await getPlacesDetail(placeId: selectedPlaces?.placeId);
    if (placeDetails == null) {
      notify();
      return;
    }

    zipcodeController.text = placeDetails?.postalCode ?? '';
    getCityStateByZipcode();

    notify();
  }

  Future<GPlaceDetails?> getPlacesDetail({required String? placeId}) async {
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

  void toggleSearchLoading(bool n) {
    isSearchLoading = n;
    notify();
  }

  void handleOnTapMap(LatLng? position) {
    if (position == null) return;
    _setupMarkers(position);
    _setupLocationNAddress(GCustomPlaces(position: position));
  }

  Future<void> getCurrentPosition(BuildContext context) async {
    loading = true;

    final res = await LocationHandler.getCurrentPosition();

    if (!res.isSuccess) {
      loading = false;
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(res.message ?? '');
      return;
    }

    final position = LatLng(res.position!.latitude, res.position!.longitude);

    _setupLocationNAddress(GCustomPlaces(position: position));

    loading = false;
    notify();
  }

  void _setupLocationNAddress(GCustomPlaces place) async {
    if (place.position == null) return;

    loading = true;
    currentPosition = place.position;
    _setupMarkers(place.position!);

    if (place.address == null) {
      final result = await _googleMapApi.getPlacesDetailsByLatLng(
          position: place.position);
      result.when((value) {
        currentAddress = place.copyWith(
          address: value.first.formattedAddress,
          placeId: value.first.placeId,
        );
      }, (error) {
        loading = false;
        notify();
      });
    } else {
      currentAddress = place;
    }

    loading = false;
    notify();
  }

  void _setupMarkers(LatLng position) {
    markers.clear();
    markers.addAll([
      Marker(
        markerId: MarkerId('Marker: ${randomId()}'),
        position: position,
        icon: _customMarker,
        draggable: false,
        // onDragEnd: ((newPosition) {}),
        infoWindow: const InfoWindow(
          title:
              'Your order will be delivered here\nMove pin to your exact location',
        ),
      ),
    ]);

    final cameraPosition = CameraPosition(target: position, zoom: 14.4746);
    gController?.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );

    notify();
  }

  Future<void> _loadCustomMarker() async {
    _customMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(20, 20)),
      AppAssets.marker,
    );
  }

  void onMapCreated(GoogleMapController controller) {
    gController = controller;
    loading = false;
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

  Future<bool> saveAddress(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) return false;

    if (cityStateData?.city == null) {
      context.showFailureSnackBar('Please select a City');
      return false;
    }

    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      final address = UserAddress(
        id: 0,
        name: clientNameController.text.trim(),
        address: addressController.text.trim(),
        address2: address2Controller.text.trim(),
        cityId: cityStateData?.city?.id ?? 0,
        zipcode: zipcodeController.text.trim(),
        phoneNumber: phoneNumberController.text.trim(),
        isDefault: false,
        userId: preferences.getUserProfile()?.id,
        latitude: markers.first.position.latitude,
        longitude: markers.first.position.longitude,
        googleAddress: displayAddress,
      );

      var result = await _userApi.addNewAddress(address: address);

      return result.when(
        (value) async {
          notify();
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
        (error) {
          if (context != null) context.showFailureSnackBar(error);
          toggleSearchLoading(false);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      if (context != null) context.showFailureSnackBar(kNoInternet);
    }
  }

  Future<LatLng?> getPlacesLatLng({required String? placeId}) async {
    if (placeId == null) return null;
    final context = kNavigatorKey.currentState?.context;
    if (context == null) return null;

    if (await ConnectivityService.isConnected) {
      searchedPlaces.clear();
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result =
          await _googleMapApi.getPlacesDetailsByPlaceId(placeId: placeId);

      return result.when(
        (value) async {
          // ignore: use_build_context_synchronously
          Loader.dismiss(context);
          FocusScope.of(context).unfocus();
          return value?.latLng;
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
}
