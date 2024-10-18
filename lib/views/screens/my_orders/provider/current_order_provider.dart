import 'dart:async';
import 'package:alcoholdeliver/apis/order_api/order_api.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/model/order.dart';
import 'package:alcoholdeliver/providers/default_change_notifier.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AutoDisposeChangeNotifierProvider<CurrentOrdersProvider> currentOrdersProvider =
    ChangeNotifierProvider.autoDispose((ref) => CurrentOrdersProvider());

class CurrentOrdersProvider extends DefaultChangeNotifier {
  final OrderApi _api = OrderApi.instance;

  DatabaseReference? tripsRef;
  StreamSubscription<DatabaseEvent>? tripSubscription;

  int _pageNumber = 1;
  num _totalResult = 0;
  List<Order> orders = [];
  bool loadMoreLoading = false;

  CurrentOrdersProvider();

  void initListener() {
    tripsRef = FirebaseDatabase.instance.ref('Trips');

    tripSubscription = tripsRef?.onChildChanged.listen((event) {
      if (event.type == DatabaseEventType.childChanged) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);

        if (data['Id'] == null || data['Status'] == null) return;
        updateOrdersStatusLocally(data['Id'], data['Status']);
      }
    });
  }

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

  void updateOrdersStatusLocally(int id, String status) {
    int index = orders.indexWhere((order) => order.id == id);
    if (index != -1) {
      orders[index] = orders[index].copyWith(status: status);
      notify();
    }
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
        status: 'Pending,Accepted,Delivering,ReadyForPickup,ReadyForDelivery,Preparing,Paid',
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
