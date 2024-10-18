import 'package:alcoholdeliver/apis/order_api/order_api.dart';
import 'package:alcoholdeliver/apis/store_api/store_api.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/model/order.dart';
import 'package:alcoholdeliver/model/store.dart';
import 'package:alcoholdeliver/providers/default_change_notifier.dart';
import 'package:alcoholdeliver/services/connectivity_service.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AutoDisposeChangeNotifierProvider<DriverHomepageProvider>
    driverHomepageProvider =
    ChangeNotifierProvider.autoDispose((ref) => DriverHomepageProvider());

class DriverHomepageProvider extends DefaultChangeNotifier {
  final StoreApi _storeApi = StoreApi.instance;
  final OrderApi _orderApi = OrderApi.instance;
  DatabaseReference? deliveryOrdersRef;

  int _pageNumber = 1;
  num _totalResult = 0;
  List<Order> orders = [];
  bool loadMoreLoading = false;

  bool isLoadingStore = false;
  List<Store> stores = [];
  List<Store> selectedStores = [];

  DriverHomepageProvider();

  void cDispose() {
    deliveryOrdersRef?.onDisconnect();
    deliveryOrdersRef = null;
  }

  void clear() {
    _pageNumber = 1;
    _totalResult = 0;
    orders.clear();
    stores.clear();
    selectedStores.clear();
    notify();
  }

  Future<void> refreshPage() async {
    _pageNumber = 1;
    _totalResult = 0;
    orders.clear();
    getAllOrders();
    notify();
  }

  void initListener() async {
    deliveryOrdersRef = FirebaseDatabase.instance.ref('DeliveryOrders');

    // Setup Listener
    deliveryOrdersRef?.onChildAdded.listen((event) {
      if (event.type == DatabaseEventType.childAdded) {
        refreshGetAllOrders();
      }
    });
  }

  bool isStoreChecked(num id) {
    final data = selectedStores.where((e) => e.id == id).toList();
    return data.isNotEmpty;
  }

  void onToggleStore(Store store) {
    final index = selectedStores.indexWhere((item) => item.id == store.id);

    if (index != -1) {
      selectedStores.removeAt(index);
    } else {
      selectedStores.add(store);
    }

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

  set setStoreLoading(bool value) {
    isLoadingStore = value;
    notify();
  }

  String? get _buildStoreId {
    if (selectedStores.isEmpty) return null;
    List<num> ids = [];
    for (final e in selectedStores) {
      ids.add(e.id ?? 0);
    }
    return ids.join(',');
  }

  void onToggle(BuildContext context, num id, bool n) async {
    int orderIndex = orders.indexWhere((e) => e.id == id);

    if (orderIndex != -1) {
      final curOrder = orders.firstWhere((e) => e.id == id);

      String newStatus = '';
      String status = curOrder.status?.toLowerCase() ?? '';

      if (status == 'delivering') {
        newStatus = 'readyfordelivery';
      } else if (status == 'readyfordelivery') {
        newStatus = 'delivering';
      }

      await setOrderStatus(context, id, newStatus);

      orders.removeWhere((e) => e.id == id);

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

      var result = await _orderApi.getAllOrders(
        page: _pageNumber,
        driverId: preferences.getUserProfile()?.id ?? 0,
        // status: 'ACCEPTED,ReadyForDelivery',
        status: 'ReadyForDelivery',
        storeIds: _buildStoreId,
        type: 'DELIVERY',
        pageSize: 100,
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

  Future<void> refreshGetAllOrders() async {
    var result = await _orderApi.getAllOrders(
      page: _pageNumber,
      driverId: preferences.getUserProfile()?.id ?? 0,
      status: 'ReadyForDelivery',
      storeIds: _buildStoreId,
      type: 'DELIVERY',
      pageSize: 100,
    );

    return result.when(
      (value) async {
        final newOrders = value.data ?? [];
        for (final newOrder in newOrders) {
          if (!orders.any((order) => order.id == newOrder.id)) {
            orders.add(newOrder);
          }
        }
        notify();
      },
      (error) => {},
    );
  }

  Future<void> setOrderStatus(
      BuildContext context, num orderId, String status) async {
    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result = await _orderApi.setOrderStatus(
        orderId: orderId,
        status: status,
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

  Future<void> getAllStores(BuildContext context) async {
    if (await ConnectivityService.isConnected) {
      setStoreLoading = true;

      final userId = preferences.getUserProfile()?.id ?? 0;

      var result = await _storeApi.getAllStores(
        page: 1,
        userId: userId,
      );

      return result.when(
        (value) async {
          setStoreLoading = false;
          stores = value.data ?? [];
        },
        (error) {
          setStoreLoading = false;
          context.showFailureSnackBar(error);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
    }
  }
}
