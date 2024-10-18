import 'package:alcoholdeliver/apis/order_api/order_api.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/model/order.dart';
import 'package:alcoholdeliver/providers/default_change_notifier.dart';
import 'package:alcoholdeliver/services/connectivity_service.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AutoDisposeChangeNotifierProvider<DriverPendingProvider> driverPendingProvider =
    ChangeNotifierProvider.autoDispose((ref) => DriverPendingProvider());

class DriverPendingProvider extends DefaultChangeNotifier {
  final OrderApi _orderApi = OrderApi.instance;

  int _pageNumber = 1;
  num _totalResult = 0;
  List<Order> orders = [];
  bool loadMoreLoading = false;

  DriverPendingProvider();

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

  void onToggle(BuildContext context, num id, bool n) async {
    await setOrderStatus(context, id);
    orders.removeWhere((e) => e.id == id);
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
        status: 'Accepted',
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

  Future<void> setOrderStatus(BuildContext context, num orderId) async {
    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result = await _orderApi.setOrderStatus(
        orderId: orderId,
        status: 'Delivering',
      );

      return result.when(
        (value) async {
          Loader.dismiss(context);
          context.showSuccessSnackBar('Status updated successfully');
        },
        (error) {
          Loader.dismiss(context);
          context.showFailureSnackBar(error);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
    }
  }
}
