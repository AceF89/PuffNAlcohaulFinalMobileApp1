import 'package:alcoholdeliver/apis/google_map_api/google_map_api.dart';
import 'package:alcoholdeliver/apis/order_api/order_api.dart';
import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/model/order.dart';
import 'package:alcoholdeliver/providers/default_change_notifier.dart';
import 'package:alcoholdeliver/services/connectivity_service.dart';
import 'package:alcoholdeliver/views/screens/homepage/provider/homepage_provider.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final AutoDisposeChangeNotifierProvider<VendorOrderTrackingProvider>
    vendorOrderTrackingProvider =
    ChangeNotifierProvider.autoDispose((ref) => VendorOrderTrackingProvider());

class VendorOrderTrackingProvider extends DefaultChangeNotifier {
  DatabaseReference? tripsRef;
  Set<Marker> driverLocation = {};
  BitmapDescriptor? customMarker;
  final GoogleMapApi _googleMapApi = GoogleMapApi.instance;
  final OrderApi _api = OrderApi.instance;

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

  void initListener(String firebaseId, context,
      {bool getLocation = false}) async {
    setMapLoading = true;
    Loader.show(context);
    await createCustomMarker();
    setMapLoading = false;
    // Loader.dismiss(context);
    // if (firebaseId.isEmpty) return;
    // setMapLoading = true;
    // Loader.show(context);

    // tripsRef = FirebaseDatabase.instance.ref('Trips/$firebaseId');
    //
    try {
      //   // Initial Read
      //   final snapshot = await tripsRef!.get();
      //
      //   if (snapshot.exists) {
      //     final data = snapshot.value as Map<dynamic, dynamic>;
      //
      //     final driverLocation = data['DriverLocation'] as String?;
      //     if (driverLocation != null) {
      //       final splitedValue = driverLocation.split(",");
      //       if (splitedValue.length == 2) {
      //         final newPosition = LatLng(double.parse(splitedValue[0]), double.parse(splitedValue[1]));
      //         _updateMarker(newPosition, useCar: true);
      //
      //         if (order != null && order?.estimateTime != null) {
      //           deliveryEstimatedTime =  order?.estimateTime;
      //         }
      //       }
      //     }
      //   }
      //
      //   setMapLoading = false;
      //   Loader.dismiss(context);
      //
      //   // Setup Listener
      //   tripsRef?.onChildChanged.listen((event) {
      //     if (event.type == DatabaseEventType.childChanged) {
      //       final documentKey = event.snapshot.key;
      //       if (documentKey != "DriverLocation") return;
      //
      //       final value = event.snapshot.value as String?;
      //       if (value == null) return;
      //
      //       final splitedValue = value.split(",");
      //       if (splitedValue.length != 2) return;
      //       final newPosition = LatLng(double.parse(splitedValue[0]), double.parse(splitedValue[1]));
      //       _updateMarker(newPosition, useCar: true);
      //
      if (order != null && order?.estimateTime != null) {
        deliveryEstimatedTime = order?.estimateTime;

        final newPosition = LatLng(
            double.parse(order!.driverLatitude.toString()),
            double.parse(order!.driverLongitude.toString()));
        _updateMarker(newPosition, useCar: true);
      }
      //   }
      // });
    } catch (error) {
      // Loader.dismiss(context);
      // setMapLoading = false;
    } finally {
      Loader.dismiss(context);
      setMapLoading = false;
    }
  }

  Future<void> getOrder(BuildContext context, num id, bool showLoader) async {
    if (await ConnectivityService.isConnected) {
      // if (showLoader) Loader.show(context);
      var result = await _api.getOrder(id: id);

      return result.when(
        (value) async {
          order = value;
          notify();
          // if (showLoader) Loader.dismiss(context);
        },
        (error) {
          // context.showFailureSnackBar(error);
          // if (showLoader) Loader.dismiss(context);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      // context.showFailureSnackBar(kNoInternet);
    }
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
      icon: useCar
          ? customMarker ?? BitmapDescriptor.defaultMarker
          : BitmapDescriptor.defaultMarker,
    ));
    notify();
  }
}
