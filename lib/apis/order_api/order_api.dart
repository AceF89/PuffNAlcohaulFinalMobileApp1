import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/helpers/preferences.dart';
import 'package:alcoholdeliver/model/order.dart';
import 'package:alcoholdeliver/model/pagination_response.dart';
import 'package:alcoholdeliver/services/client/client_service.dart';
import 'package:alcoholdeliver/services/client/result.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'order_api_impl.dart';

abstract class OrderApi {
  static final OrderApi _instance = _OrderApiImpl();

  static OrderApi get instance => _instance;

  Future<Result<Pagination<List<Order>>, String>> getAllOrders({
    required int page,
    required String status,
    num? customerId,
    num? driverId,
    num? pageSize = 20,
    String? storeIds,
    String? filters,
    String? type,
  });

  Future<Result<String, String>> saveOrder({required Order item});

  Future<Result<String, String>> preCheckout({
    required num tip,
    required DateTime tipscheduleDate,
    required String orderType,
    // required num frontLicenceFileId,
    // required num backLicenseFileId,
  });

  Future<Result<Order, String>> getOrder({required num id});

  Future<Result<String, String>> setOrderStatus({required num orderId, required String status, String? reason});

  Future<Result<String, String>> setOrderType({required num orderId, required String orderType});

  Future<Result<String, String>> applyLoyaltyPoints({required num orderId, required num points});

  Future<Result<String, String>> updateDriverLocation({required LocationDto location});

  Future<Result<String, String>> updateDriverLocationFormLatLong({required LatLng location});
}
