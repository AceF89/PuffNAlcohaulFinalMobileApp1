import 'dart:async';
import 'package:alcoholdeliver/services/location/background_locator_repository.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:flutter/material.dart';

@pragma('vm:entry-point')
class BackgroundLocatorCallabacks {
  static final BackgroundLocatorRepository _repository = BackgroundLocatorRepository();

  @pragma('vm:entry-point')
  static Future<void> initCallback(Map<dynamic, dynamic> params) async {
    await _repository.init(params);
  }

  @pragma('vm:entry-point')
  static Future<void> disposeCallback() async {
    await _repository.dispose();
  }

  @pragma('vm:entry-point')
  static Future<void> callback(LocationDto locationDto) async {
    await _repository.callback(locationDto);
  }

  @pragma('vm:entry-point')
  static Future<void> notificationCallback() async {
    debugPrint('📍 BG Location #Notification Callback');
  }
}
