import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/model/google/location_result.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

class LocationService {
  LocationService._();

  static Stream<ServiceStatus> get getServiceStatusStream => Geolocator.getServiceStatusStream();

  static Future<bool> get checkServiceStatus => Geolocator.isLocationServiceEnabled();

  static Future<void> openLocationSettings(BuildContext context) async {
    bool opened = await Geolocator.openLocationSettings();
    if (!opened) {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar('Couldn\'t access location settings page, Please enable it from System Settings');
    }
  }

  static Future<LocationResult> getCurrentLocation() async {
    LocationResult result = LocationResult(status: false, latitude: 0.0, longitude: 0.0);
    LocationPermission permission = await _checkAndRequestPermission();

    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        result
          ..status = true
          ..message = 'Location service is enabled and permission is granted.'
          ..latitude = position.latitude
          ..longitude = position.longitude;
      } catch (e) {
        result
          ..status = false
          ..message = e.toString();
      }
    }

    return result;
  }

  static Future<bool> checkPermission({bool requestPermission = false}) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied && requestPermission) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  static Future<bool> getAlwaysLocationPermission() async {
    ph.PermissionStatus status = await ph.Permission.locationWhenInUse.request();
    if (status.isGranted) {
      return true;
    }
    ph.openAppSettings();
    return false;
  }

  static Future<LocationPermission> _checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    return permission;
  }
}
