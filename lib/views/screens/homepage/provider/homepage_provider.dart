import 'package:alcoholdeliver/apis/categories_api/categories_api.dart';
import 'package:alcoholdeliver/apis/order_api/order_api.dart';
import 'package:alcoholdeliver/apis/product_api/product_api.dart';
import 'package:alcoholdeliver/apis/snippet_api/snippet_api.dart';
import 'package:alcoholdeliver/apis/user_api/user_api.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/model/google/location_result.dart';
import 'package:alcoholdeliver/model/order.dart';
import 'package:alcoholdeliver/model/product.dart';
import 'package:alcoholdeliver/model/product_categories.dart';
import 'package:alcoholdeliver/model/snippets.dart';
import 'package:alcoholdeliver/model/user_address.dart';
import 'package:alcoholdeliver/providers/default_change_notifier.dart';
import 'package:alcoholdeliver/services/connectivity_service.dart';
import 'package:alcoholdeliver/services/location/location_service.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ChangeNotifierProvider<HomepageProvider> homepageProvider =
ChangeNotifierProvider((ref) => HomepageProvider());

class HomepageProvider extends DefaultChangeNotifier {
  final UserApi _userApi = UserApi.instance;
  final OrderApi _orderApi = OrderApi.instance;
  final SnippetApi _snippetApi = SnippetApi.instance;
  final ProductApi _productApi = ProductApi.instance;
  final CategoriesApi _categoriesApi = CategoriesApi.instance;
  LocationResult? userLocationValue;
  List<ProductCategories> categories = [];
  UserAddress? defaultAddress;

  bool isLoadingFeature = false;
  List<Product> featuredProducts = [];

  List<Snippets> snippets = [];

  int _pageNumber = 1;
  num _totalResult = 0;
  List<Order> orders = [];
  bool loadMoreLoading = false;
  bool isLoadingDeliveryOrder = false;

  DatabaseReference? deliveryOrdersRef;

  void reloadDeliveryOrders() {
    _pageNumber = 1;
    _totalResult = 0;
    orders.clear();
    getAllDeliveryOrders();
    notify();
  }

  listenUserLocation(context) async {
    try {
      userLocationValue = await LocationService.getCurrentLocation();
      print("value?.latitude ===> ${userLocationValue?.latitude}");
      print("value?.longitude ===> ${userLocationValue?.longitude}");
      pingUser(lat: userLocationValue?.latitude ?? 0.0, long: userLocationValue?.longitude ?? 0.0, context: context);
      notify();
    } catch (e) {
      print("Error ===> $e");
    }
  }

  HomepageProvider();

  void initListener() async {
    deliveryOrdersRef = FirebaseDatabase.instance.ref('Trips');

    // Setup Listener
    deliveryOrdersRef?.onChildChanged.listen((event) {
      if (event.type == DatabaseEventType.childChanged) {
        refreshGetAllOrders();
      }
    });
  }

  void cDispose() {
    deliveryOrdersRef?.onDisconnect();
    deliveryOrdersRef = null;
  }

  set setLoadMoreLoading(bool value) {
    loadMoreLoading = value;
    notify();
  }

  Future<void> refreshPage() async {
    _pageNumber = 1;
    _totalResult = 0;
    orders.clear();
    getAllDeliveryOrders();
    notify();
  }

  set toggleFeatureLoading(bool n) {
    isLoadingFeature = n;
    notify();
  }

  Future<void> loadMoreOrders() async {
    if (_totalResult != orders.length) {
      var result = await getAllDeliveryOrders(
        isLoadMore: true,
      );
      if (result.isNotEmpty) {
        orders.addAll(result);
        notify();
      }
    }
  }

  Future<void> getMe(BuildContext context) async {
    if (await ConnectivityService.isConnected) {
      var result = await _userApi.getMe();

      return result.when(
            (value) async {
          final oldUser = preferences.getUserProfile();
          final updatedProfile = value.copyWith(token: oldUser?.token);
          preferences.userProfile = updatedProfile;
          notify();
        },
            (error) => context.showFailureSnackBar(error),
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
    }
  }

  Future<void> pingUser({required double lat, required double long,required BuildContext context}) async {
    if (await ConnectivityService.isConnected) {
      await _userApi.pingUser(lat: lat, long: long);
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
    }
  }

  Future<void> getDefaultAddress() async {
    final context = kNavigatorKey.currentState?.context;

    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      if (context != null) Loader.show(context);

      var result = await _userApi.getAllAddress(defaultAddress: true);

      return result.when(
            (value) async {
          if (value.isNotEmpty) {
            defaultAddress = value.first;
          }
          notify();
          if (context != null) Loader.dismiss(context);
        },
            (error) {
          if (context != null) Loader.dismiss(context);
          if (context != null) context.showFailureSnackBar(error);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      if (context != null) context.showFailureSnackBar(kNoInternet);
    }
  }

  Future<List<Order>> getAllDeliveryOrders({
    bool isLoadMore = false,
  }) async {
    try {
      if (isLoadMore) {
        _pageNumber++;
        setLoadMoreLoading = true;
      } else {
        isLoadingDeliveryOrder = true;
      }

      var result = await _orderApi.getAllOrders(
        page: _pageNumber,
        status: 'Accepted,Delivering,ReadyForDelivery,Paid,PREPARING',
        customerId: preferences.getUserProfile()?.id ?? 0,
        type: 'DELIVERY',
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
      isLoadMore ? setLoadMoreLoading = false : isLoadingDeliveryOrder = false;
    }
  }

  Future<void> refreshGetAllOrders() async {
    var result = await _orderApi.getAllOrders(
      page: _pageNumber,
      status: 'Accepted,Delivering,ReadyForDelivery,Paid,PREPARING',
      customerId: preferences.getUserProfile()?.id ?? 0,
      type: 'DELIVERY',
      pageSize: 100,
    );

    return result.when(
          (value) async {
        final newOrders = value.data ?? [];
        orders = newOrders;
        // for (final newOrder in newOrders) {
        //   // if (!orders.any((order) => order.id == newOrder.id)) {
        //   //   orders.add(newOrder);
        //   // }
        //   // check if status changed for new order and update it
        //   // final existingOrderIndex =
        //   //     orders.indexWhere((order) => order.id == newOrder.id);
        //   // if (existingOrderIndex != -1) {
        //   //   // Update the existing order
        //   //   orders[existingOrderIndex] = newOrder;
        //   // } else {
        //   //   // Add the new order
        //   //   orders.add(newOrder);
        //   // }
        //   orders.add(newOrder);
        // }
        notify();
      },
          (error) => {},
    );
  }

  Future<void> getAllCategories(BuildContext context) async {
    if (await ConnectivityService.isConnected) {
      loading = true;
      var result = await _categoriesApi.getAllCategories(
        storeId: preferences.getUserProfile()?.storeId ?? 0,
      );

      return result.when(
            (value) async {
          categories = value;
          loading = false;
          notify();
        },
            (error) {
          loading = false;
          context.showFailureSnackBar(error);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
    }
  }

  Future<void> getSnippets() async {
    if (await ConnectivityService.isConnected) {
      var result = await _snippetApi.getAllSnippet(
        page: 1,
        query: 'HOMEPAGE_BANNER',
      );

      return result.when(
            (value) async {
          snippets = value;
          notify();
        },
            (error) {},
      );
    }
  }

  Future<void> getAllFeatureProduct(BuildContext context) async {
    if (await ConnectivityService.isConnected) {
      toggleFeatureLoading = true;
      var result = await _productApi.getAllProduct(
        page: 1,
        type: GetAllProductE.featured,
      );

      return result.when(
            (value) async {
          featuredProducts = value.data ?? [];
          toggleFeatureLoading = false;
          notify();
        },
            (error) {
          toggleFeatureLoading = false;
          context.showFailureSnackBar(error);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
    }
  }

  Future<void> setPlayerId(String playerId) async {
    if (await ConnectivityService.isConnected) {
      var result = await _userApi.setPlayerId(id: playerId);

      return result.when((value) {}, (error) {});
    }
  }

  Future<bool> setOrderStatus(
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
}
