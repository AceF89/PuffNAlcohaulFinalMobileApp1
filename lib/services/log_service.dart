import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LogglyService {
  LogglyService();

  Dio dio = Dio();

  Future<void> log(Map<String, dynamic> data, {String level = 'info'}) async {
    const logUrl =
        'http://logs-01.loggly.com/inputs/2a14cc21-085e-4098-a0d7-bd837d3498cc/tag/http/';

    try {
      final response = await dio.post(
        logUrl,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: data,
      );

      if (response.statusCode != 200) {
        if (kDebugMode) {
          print('Failed to log to Loggly: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error logging to Loggly: $e');
      }
    }
  }
}


LogglyService logglyService = LogglyService();