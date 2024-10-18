import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:alcoholdeliver/services/client/client_service.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);

    String? token = preferences.getUserProfile()?.token;

    if (token != null) {
      options.headers = HeaderBuilder().setBearerToken(token).build();
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    if (err.response?.statusCode == 401) {
      preferences.clear();
      BuildContext? context = kNavigatorKey.currentContext;
      if (context == null) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.loginScreen,
        (Route<dynamic> route) => false,
      );
    }
  }
}
