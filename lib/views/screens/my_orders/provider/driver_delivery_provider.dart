import 'dart:io';
import 'package:alcoholdeliver/apis/order_api/order_api.dart';
import 'package:alcoholdeliver/apis/user_api/user_api.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/core/utils/file_utils.dart';
import 'package:alcoholdeliver/model/file_upload_response.dart';
import 'package:alcoholdeliver/model/order.dart';
import 'package:alcoholdeliver/providers/default_change_notifier.dart';
import 'package:alcoholdeliver/services/connectivity_service.dart';
import 'package:alcoholdeliver/views/dialog/upload_file_dialog.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AutoDisposeChangeNotifierProvider<DriverDeliveryProvider> driverDeliveryProvider =
    ChangeNotifierProvider.autoDispose((ref) => DriverDeliveryProvider());

class DriverDeliveryProvider extends DefaultChangeNotifier {
  final UserApi _userApi = UserApi.instance;
  final OrderApi _orderApi = OrderApi.instance;

  int _pageNumber = 1;
  num _totalResult = 0;
  List<Order> orders = [];
  bool loadMoreLoading = false;

  File? doorImage;
  final TextEditingController reasonController = TextEditingController();

  DriverDeliveryProvider();

  void clear() {
    _pageNumber = 1;
    _totalResult = 0;
    orders.clear();
    notify();
  }

  Future<void> refreshPage() async {
    _pageNumber = 1;
    _totalResult = 0;
    orders.clear();
    getAllOrders();
    notify();
  }

  set setLoadMoreLoading(bool value) {
    loadMoreLoading = value;
    notify();
  }

  Future<void> loadMoreOrders() async {
    if (_totalResult != orders.length) {
      var result = await getAllOrders(
        isLoadMore: true,
      );
      if (result.isNotEmpty) {
        orders.addAll(result);
        notify();
      }
    }
  }

  Future<void> onSelectImage(BuildContext context) async {
    var file = await UploadFileDialog.show(context, useGallery: Platform.isIOS);
    if (file == null) return;

    if (file.size <= kMaximumFileSize) {
      doorImage = file;
      notify();
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar('You can upload maximum file size upto $kMaximumFileSize MB');
    }
  }

  Future<FileUploadResponse?> uploadFile(BuildContext context, File? file) async {
    if (file == null) return null;

    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result = await _userApi.uploadFile(file);

      return result.when(
        (value) async {
          Loader.dismiss(context);
          return value;
        },
        (error) {
          Loader.dismiss(context);
          context.showFailureSnackBar(error);
          return null;
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
      return null;
    }
  }

  Future<bool> updateImageId(BuildContext context, Order order) async {
    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result = await _orderApi.saveOrder(item: order);

      return result.when(
        (value) async {
          Loader.dismiss(context);
          return true;
        },
        (error) {
          Loader.dismiss(context);
          context.showFailureSnackBar(error);
          return false;
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
      return false;
    }
  }

  Future<bool> setOrderStatus(BuildContext context, num orderId, String status, {String? reason}) async {
    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result = await _orderApi.setOrderStatus(
        orderId: orderId,
        status: status,
        reason: reason,
      );

      return result.when(
        (value) async {
          Loader.dismiss(context);
          orders.removeWhere((e) => e.id == orderId);
          context.showSuccessSnackBar('Status updated successfully');
          notify();
          return true;
        },
        (error) {
          Loader.dismiss(context);
          context.showFailureSnackBar(error);
          return false;
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
      return false;
    }
  }

  Future<List<Order>> getAllOrders({
    bool isLoadMore = false,
  }) async {
    try {
      if (isLoadMore) {
        _pageNumber++;
        setLoadMoreLoading = true;
      } else {
        loading = true;
      }

      var result = await _orderApi.getAllOrders(
        page: _pageNumber,
        driverId: preferences.getUserProfile()?.id ?? 0,
        status: 'Delivering',
      );

      return result.when(
        (value) async {
          _totalResult = value.totalData;
          if (!isLoadMore) orders = value.data ?? [];
          return value.data ?? [];
        },
        (error) {
          orders = [];
          return [];
        },
      );
    } finally {
      isLoadMore ? setLoadMoreLoading = false : loading = false;
    }
  }
}
