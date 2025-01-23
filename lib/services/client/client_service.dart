import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/services/client/interceptor.dart';
import 'package:alcoholdeliver/services/client/result.dart';
import 'package:alcoholdeliver/services/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

bool _kEnabledLogs = kDebugMode && true;

enum RequestType { post, get, patch, delete }

class ClientService {
  final Dio _dio;

  ClientService() : _dio = Dio();

  // final String _baseUrl = 'https://st-alcohol-apis.npit.pro/api';
  final String _baseUrl = 'https://api.puffnalcohaul.com/api';
  // final String _baseUrl = 'https://alcohol-apis.npit.pro/api';

  Future<Result<dynamic, String>> request({
    required RequestType requestType,
    required String? path,
    dynamic data,
    Options? headers,
  }) async {
    String url = '$_baseUrl$path';

    _dio.interceptors.clear();
    _dio.interceptors.addAll([
      AuthInterceptor(),
      if (kDebugMode)
        LogInterceptor(
          request: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
        ),
    ]);

    Response? response;

    // logglyService.log({
    //   'endpoint': path,
    //   'requestBody': data,
    //   'method': jsonEncode(requestType.toString()),
    //   'level': 'production',
    //   'message': 'Api Call',
    //   'optinos': jsonEncode(headers.toString()),
    //   'url': url,
    // }, level: 'API Call');

    try {
      if (await ConnectivityService.isConnected) {
        switch (requestType) {
          // Send a POST request with the given parameter.
          case RequestType.post:
            response = await _dio.post(url, data: data, options: headers);
            break;

          // Send a GET request with the given parameter.
          case RequestType.get:
            response = await _dio.get(url, options: headers);
            break;

          // Send a DELETE request with the given parameter.
          case RequestType.patch:
            response = await _dio.patch(url, data: data);
            break;

          // Send a DELETE request with the given parameter.
          case RequestType.delete:
            response = await _dio.delete(url);
            break;

          default:
            throw RequestTypeNotFoundException('The HTTP request mentioned is not found');
        }
        // logglyService.log({
        //   'endpoint': path,
        //   'requestBody': data,
        //   'method': jsonEncode(requestType.toString()),
        //   'response': jsonEncode(response.toString()),
        //   'level': 'production',
        //   'message': 'Api Response',
        //   'optinos': jsonEncode(headers.toString()),
        //   'url': url,
        // }, level: 'API Call');
        return Success(response.data);
      } else {
        // logglyService.log({
        //   'endpoint': path,
        //   'requestBody': data,
        //   'method': jsonEncode(requestType.toString()),
        //   'error': 'No Internet',
        //   'level': 'production',
        //   'message': 'Api Response',
        //   'optinos': jsonEncode(headers.toString()),
        //   'url': url,
        // }, level: 'API Call');
        Fluttertoast.showToast(
          msg: kNoInternet,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return Failure(kNoInternet);
      }
    } on DioError catch (e, _) {
      if (e.response?.statusCode == 500) {
        // logglyService.log({
        //   'endpoint': path,
        //   'requestBody': data,
        //   'method': jsonEncode(requestType.toString()),
        //   'error': e.message.toString(),
        //   'stacktrace': stack.toString(),
        //   'response': jsonEncode(e.toString()),
        //   'level': 'production',
        //   'message': 'Api Response',
        //   'optinos': jsonEncode(headers.toString()),
        //   'url': url,
        // }, level: 'API Call');
        return Failure(e.message.toString());
      } else {
        var message = e.response?.data['message'] ?? 'Something went wrong.';
        // logglyService.log({
        //   'endpoint': path,
        //   'requestBody': data,
        //   'method': jsonEncode(requestType.toString()),
        //   'error': message,
        //   'stacktrace': stack.toString(),
        //   'response': jsonEncode(e.toString()),
        //   'level': 'production',
        //   'message': 'Api Response',
        //   'optinos': jsonEncode(headers.toString()),
        //   'url': url,
        // }, level: 'API Call');
        return Failure(message);
      }
    } catch (e, _) {
      // logglyService.log({
      //   'endpoint': path,
      //   'requestBody': data,
      //   'method': jsonEncode(requestType.toString()),
      //   'error': e.toString(),
      //   'stacktrace': stack.toString(),
      //   'level': 'production',
      //   'message': 'Api Response',
      //   'optinos': jsonEncode(headers.toString()),
      //   'url': url,
      // }, level: 'API Call');
      return Failure(e.toString());
    }
  }

  Future<Result<dynamic, String>> urlRequest({
    required RequestType requestType,
    required String url,
    dynamic data,
    dynamic headers,
  }) async {
    _dio.interceptors.clear();
    _dio.interceptors.addAll([
      if (kDebugMode)
        LogInterceptor(
          request: false,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
        ),
    ]);

    Response? response;

    try {
      if (await ConnectivityService.isConnected) {
        switch (requestType) {
          // Send a POST request with the given parameter.
          case RequestType.post:
            response = await _dio.post(
              url,
              data: data,
              options: Options(headers: headers),
            );
            break;

          // Send a GET request with the given parameter.
          case RequestType.get:
            response = await _dio.get(url, options: Options(headers: headers));
            break;

          // Send a DELETE request with the given parameter.
          case RequestType.patch:
            response = await _dio.patch(
              url,
              data: data,
              options: Options(headers: headers),
            );
            break;

          // Send a DELETE request with the given parameter.
          case RequestType.delete:
            response = await _dio.delete(
              url,
              options: Options(headers: headers),
            );
            break;

          default:
            throw RequestTypeNotFoundException('The HTTP request mentioned is not found');
        }
        return Success(response.data);
      } else {
        return Failure(kNoInternet);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 500) {
        return Failure(e.message.toString());
      } else {
        var message = e.response?.data['message'] ?? 'Something went wrong.';
        return Failure(message);
      }
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<Result<dynamic, String>> getRequest({required String url}) async {
    Options options = Options(
      responseType: ResponseType.json,
      contentType: 'application/json',
    );
    try {
      _dio.interceptors.addAll([
        if (kDebugMode)
          LogInterceptor(
            request: false,
            requestBody: true,
            responseHeader: false,
            responseBody: true,
          ),
      ]);

      final Response response = await _dio.get(url, options: options);
      if (response.statusCode == 200) {
        return Success(response.data);
      }
      return Failure(response.statusMessage ?? '');
    } on DioError catch (e) {
      return Failure(e.message.toString());
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<Result<String, String>> download({
    required String path,
    required String savePath,
  }) async {
    _dio.interceptors.clear();
    _dio.interceptors.addAll([
      if (_kEnabledLogs)
        LogInterceptor(
          request: false,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
        ),
    ]);

    try {
      await _dio.download(path, savePath);
      return Success('File Downloaded successfully');
    } on DioError catch (e) {
      return Failure(e.message);
    } on FileSystemException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}

// Request type not found exception
class RequestTypeNotFoundException implements Exception {
  String cause;
  RequestTypeNotFoundException(this.cause);
}

class HeaderBuilder {
  final Map<String, String> _header;

  HeaderBuilder() : _header = {};

  HeaderBuilder setContentType(String type) {
    _header['Content-Type'] = type;
    return this;
  }

  HeaderBuilder setBearerToken(String token) {
    _header['Authorization'] = 'Bearer $token';
    return this;
  }

  Map<String, String> build() => _header;
}
