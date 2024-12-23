import 'package:alcoholdeliver/apis/google_map_api/google_map_api.dart';
import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/model/order.dart';
import 'package:alcoholdeliver/providers/default_change_notifier.dart';
import 'package:alcoholdeliver/services/connectivity_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final AutoDisposeChangeNotifierProvider<VendorOrderTrackingProvider> vendorOrderTrackingProvider =
    ChangeNotifierProvider.autoDispose((ref) => VendorOrderTrackingProvider());

class VendorOrderTrackingProvider extends DefaultChangeNotifier {
  DatabaseReference? tripsRef;
  Set<Marker> driverLocation = {};
  BitmapDescriptor? customMarker;
  final GoogleMapApi _googleMapApi = GoogleMapApi.instance;

  Order? order;
  DateTime? _lastEstimatedTimeCall;

  bool isMapLoading = false;

  String? deliveryEstimatedTime;
  bool isEstimatedTimeLoading = false;

  VendorOrderTrackingProvider();

  void cDispose() {
    // timer?.cancel();
    tripsRef?.onDisconnect();
    tripsRef = null;
    order = null;
  }

  bool get isLocationAvailable => driverLocation.isNotEmpty;

  LatLng? get originCoordinate {
    return isLocationAvailable ? driverLocation.first.position : null;
  }

  set setMapLoading(bool value) {
    isMapLoading = value;
    notify();
  }

  set setEstimatedLoading(bool value) {
    isEstimatedTimeLoading = value;
    notify();
  }

  void setOrder(Order nOrder) {
    order = nOrder;
    notify();
  }

  void initListener(String firebaseId) async {
    setMapLoading = true;
    await createCustomMarker();
    setMapLoading = false;
    if (firebaseId.isEmpty) return;
    setMapLoading = true;
    tripsRef = FirebaseDatabase.instance.ref('Trips/$firebaseId');

    // Initial Read
    final snapshot = await tripsRef!.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;

      final driverLocation = data['DriverLocation'] as String?;
      if (driverLocation != null) {
        final splitedValue = driverLocation.split(",");
        if (splitedValue.length == 2) {
          final newPosition = LatLng(double.parse(splitedValue[0]), double.parse(splitedValue[1]));
          _updateMarker(newPosition, useCar: true);

          if (order != null && order?.destinationCoordinate != null) {
            getEstimatedTime(originCoordinate, order!.destinationCoordinate, showLoader: false);
          }
        }
      }
    }

    setMapLoading = false;

    // Setup Listener
    tripsRef?.onChildChanged.listen((event) {
      if (event.type == DatabaseEventType.childChanged) {
        final documentKey = event.snapshot.key;
        if (documentKey != "DriverLocation") return;

        final value = event.snapshot.value as String?;
        if (value == null) return;

        final splitedValue = value.split(",");
        if (splitedValue.length != 2) return;
        final newPosition = LatLng(double.parse(splitedValue[0]), double.parse(splitedValue[1]));
        _updateMarker(newPosition, useCar: true);

        if (order != null && order?.destinationCoordinate != null) {
          getEstimatedTime(originCoordinate, order!.destinationCoordinate, showLoader: false);
        }
      }
    });
  }

  Future<void> createCustomMarker() async {
    customMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      AppAssets.carMarkerSmall,
    );
  }

  void _updateMarker(LatLng position, {bool useCar = false}) {
    driverLocation.clear();
    driverLocation.add(Marker(
      markerId: const MarkerId('Driver'),
      position: position,
      icon: useCar ? customMarker ?? BitmapDescriptor.defaultMarker : BitmapDescriptor.defaultMarker,
    ));
    notify();
  }

  Future<void> getEstimatedTime(LatLng? orgin, LatLng? destination, {bool showLoader = true}) async {
    final now = DateTime.now();

    if (_lastEstimatedTimeCall != null && now.difference(_lastEstimatedTimeCall!).inMinutes < 1) {
      return;
    }

    _lastEstimatedTimeCall = now;

    if (orgin == null || destination == null) {
      deliveryEstimatedTime = null;
      setEstimatedLoading = false;
      notify();
      return;
    }

    if (await ConnectivityService.isConnected) {
      if (showLoader) deliveryEstimatedTime = null;
      if (showLoader) setEstimatedLoading = true;

      var result = await _googleMapApi.getEstimatedTime(origin: orgin, destination: destination);

      return result.when(
        (value) async {
          if (showLoader) setEstimatedLoading = false;
          deliveryEstimatedTime = value.estimatedTime;
          notify();
        },
        (error) {
          if (showLoader) setEstimatedLoading = false;
        },
      );
    } else {
      if (showLoader) setEstimatedLoading = false;
    }
  }
}
