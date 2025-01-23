import 'package:alcoholdeliver/apis/google_map_api/google_map_api.dart';
import 'package:alcoholdeliver/apis/order_api/order_api.dart';
import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/model/order.dart';
import 'package:alcoholdeliver/providers/default_change_notifier.dart';
import 'package:alcoholdeliver/services/connectivity_service.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final AutoDisposeChangeNotifierProvider<UserOrderTrackingProvider>
    userOrderTrackingProvider =
    ChangeNotifierProvider.autoDispose((ref) => UserOrderTrackingProvider());

class UserOrderTrackingProvider extends DefaultChangeNotifier {
  DatabaseReference? tripsRef;
  Set<Marker> driverLocation = {};
  BitmapDescriptor? customMarker;
  final OrderApi _api = OrderApi.instance;
  final GoogleMapApi _googleMapApi = GoogleMapApi.instance;

  Order? order;
  DateTime? _lastEstimatedTimeCall;

  bool isMapLoading = false;

  String? deliveryEstimatedTime;
  bool isEstimatedTimeLoading = false;

  UserOrderTrackingProvider();

  void cDispose() {
    // timer?.cancel();
    tripsRef?.onDisconnect();
    tripsRef = null;
    order = null;
  }

  bool get isLocationAvailable => driverLocation.isNotEmpty;

  LatLng? get originCoordinate {
    return isLocationAvailable
        ? driverLocation.last.position
        : order?.originCoordinate;
  }

  LatLng? get destinationCoordinate {
    return order?.destinationCoordinate;
  }

  set setMapLoading(bool value) {
    isMapLoading = value;
    notify();
  }

  set setEstimatedLoading(bool value) {
    isEstimatedTimeLoading = value;
    notify();
  }

  void initListener(String firebaseId, bool showLoader) async {
    try {
      if (showLoader) setMapLoading = true;
      await createCustomMarker();

      // if (firebaseId.isEmpty) {
      //   setMapLoading = false;
      //   return;
      // }

      // tripsRef = FirebaseDatabase.instance.ref('Trips/$firebaseId');

      // // Initial Read
      // final snapshot = await tripsRef!.get();
      // if (snapshot.exists) {
      //   final data = snapshot.value as Map<dynamic, dynamic>;
      //
      //   final driverLocation = data['DriverLocation'] as String?;
      //   if (driverLocation != null) {
      //     final splitedValue = driverLocation.split(",");
      //     if (splitedValue.length == 2) {
      //       final newPosition = LatLng(
      //           double.parse(splitedValue[0]), double.parse(splitedValue[1]));
      //       _updateMarker(newPosition, useCar: true);
      //
      //       if (order != null && order?.estimateTime != null) {
      //         deliveryEstimatedTime =  order?.estimateTime;
      //       }
      //     }
      //   }
      // }
      //
      // setMapLoading = false;
      //
      // // Setup Listener
      // tripsRef?.onChildChanged.listen((event) {
      //   // if (event.type == DatabaseEventType.childChanged) {
      //   final documentKey = event.snapshot.key;
      //   if (documentKey != "DriverLocation") return;
      //
      //   final value = event.snapshot.value as String?;
      //   if (value == null) return;
      //
      //   final splitedValue = value.split(",");
      //   if (splitedValue.length != 2) return;
      //   final newPosition = LatLng(
      //       double.parse(splitedValue[0]), double.parse(splitedValue[1]));
      //   _updateMarker(newPosition, useCar: true);

      if (order != null && order?.estimateTime != null) {
        deliveryEstimatedTime = order?.estimateTime;
        final newPosition = LatLng(
                double.parse(order!.driverLatitude.toString()), double.parse(order!.driverLongitude.toString()));
          _updateMarker(newPosition, useCar: true);
      }
      // }
      // });
    } catch (e) {
      print("Error in initListener: $e");
    } finally {
      setMapLoading = false;
    }
  }

  Future<void> createCustomMarker() async {
    customMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      AppAssets.carMarkerSmall,
    );
  }

  void _updateMarker(LatLng position, {bool useCar = false}) {
    print("driver position ==> ${position.latitude} -> ${position.longitude}");
    driverLocation.clear();
    driverLocation.add(Marker(
      markerId: const MarkerId('Driver'),
      position: position,
      icon: useCar
          ? customMarker ?? BitmapDescriptor.defaultMarker
          : BitmapDescriptor.defaultMarker,
    ));
    notify();
  }

  Future<void> getOrder(BuildContext context, num id, bool showLoader) async {
    if (await ConnectivityService.isConnected) {
      if (showLoader) Loader.show(context);
      var result = await _api.getOrder(id: id);

      return result.when(
        (value) async {
          order = value;
          notify();
          if (showLoader) Loader.dismiss(context);
        },
        (error) {
          context.showFailureSnackBar(error);
          if (showLoader) Loader.dismiss(context);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
    }
  }
}
