import 'dart:io';
import 'package:location/location.dart';

const int _kInterval = 15000;

class BackgroundLocationService {
  final Location _location;

  BackgroundLocationService() : _location = Location();

  final LocationAccuracy _accuracy = Platform.isIOS ? LocationAccuracy.navigation : LocationAccuracy.high;

  Future<void> enableBackgroundMode(bool enable) async {
    await _location.enableBackgroundMode(enable: enable);
  }

  Future<bool> requestService() async => await _location.requestService();

  Future<void> changeSettings() async {
    await _location.changeSettings(accuracy: _accuracy, interval: _kInterval);
  }

  Stream<LocationData> get onLocationChanged => _location.onLocationChanged;
}
