import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';
import 'package:alcoholdeliver/apis/order_api/order_api.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:flutter/material.dart';

class BackgroundLocatorRepository {
  int count = -1;
  static const String isolateName = 'LocatorIsolate';
  static final BackgroundLocatorRepository _instance = BackgroundLocatorRepository._();

  BackgroundLocatorRepository._();

  factory BackgroundLocatorRepository() => _instance;

  Future<void> init(Map<dynamic, dynamic> params) async {
    debugPrint('📍 BG Location #Init Callback Handler');
    count = _parseCount(params['countInit']) ?? 0;
    _sendToIsolate(null);
  }

  Future<void> dispose() async {
    debugPrint('📍 BG Location #Dispose Callback Handler');
    _sendToIsolate(null);
  }

  Future<void> callback(LocationDto locationDto) async {
    debugPrint('📍 BG Location #Callback Function');
    updateLocation(locationDto);
    _sendToIsolate(locationDto.toJson());
    count++;
  }

  Future<void> updateLocation(LocationDto location) async {
    final OrderApi api = OrderApi.instance;
    await api.updateDriverLocation(location: location);
  }

  void _sendToIsolate(dynamic message) {
    final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(message);
  }

  int? _parseCount(dynamic countInit) {
    if (countInit == null) return null;
    if (countInit is int) return countInit;
    if (countInit is double) return countInit.toInt();
    if (countInit is String) return int.tryParse(countInit);
    return -2;
  }

  static double dp(double val, int places) {
    final num mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  static String formatDateLog(DateTime date) {
    return '${date.hour}:${date.minute}:${date.second}';
  }

  static String formatLog(LocationDto locationDto) {
    return '${dp(locationDto.latitude, 4)} ${dp(locationDto.longitude, 4)}';
  }
}
