import 'package:alcoholdeliver/apis/order_api/order_api.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/model/order.dart';
import 'package:alcoholdeliver/providers/default_change_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AutoDisposeChangeNotifierProvider<AllOrdersProvider> allOrdersProvider =
    ChangeNotifierProvider.autoDispose((ref) => AllOrdersProvider());

class AllOrdersProvider extends DefaultChangeNotifier {
  final OrderApi _api = OrderApi.instance;

  int _pageNumber = 1;
  num _totalResult = 0;
  List<Order> orders = [];
  bool loadMoreLoading = false;

  AllOrdersProvider();

  set setLoadMoreLoading(bool value) {
    loadMoreLoading = value;
    notify();
  }

  Future<void> refreshPage() async {
    _pageNumber = 1;
    _totalResult = 0;
    orders.clear();
    getAllOrders();
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

      var result = await _api.getAllOrders(
        page: _pageNumber,
        status: '',
        customerId: preferences.getUserProfile()?.id ?? 0,
        filters: 'NOTCART',
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