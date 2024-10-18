import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocResponse {
  final String? message;
  final Position? position;
  final bool isSuccess;

  LocResponse({this.message, this.position, required this.isSuccess});
}

class LocationHandler {
  static Future<LocResponse> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocResponse(isSuccess: false, message: 'Please turn on the location serivce');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocResponse(isSuccess: false, message: 'Location permission denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return LocResponse(
        isSuccess: false,
        message: 'Location permissions are permanently denied, we cannot request permissions',
      );
    }
    return LocResponse(isSuccess: true, message: 'Got Location Permission Successfully');
  }

  static Future<LocResponse> getCurrentPosition() async {
    try {
      final hasPermission = await handleLocationPermission();
      if (!hasPermission.isSuccess) return hasPermission;

      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return LocResponse(isSuccess: true, message: 'Got Location Successfully', position: position);
    } catch (e) {
      return LocResponse(isSuccess: false, message: 'Something went wrong while getting position');
    }
  }

  static Future<Placemark?> getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      return placeMarks[0];
    } catch (e) {
      return null;
    }
  }
}
