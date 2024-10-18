part of 'order_api.dart';

abstract class OrderApiService extends ClientService implements OrderApi {}

class _OrderApiImpl extends OrderApiService {
  @override
  Future<Result<Pagination<List<Order>>, String>> getAllOrders({
    required int page,
    required String status,
    num? customerId,
    num? driverId,
    num? pageSize = 20,
    String? storeIds,
    String? filters,
    String? type,
  }) async {
    String url = '/Order/GetAll?pageNumber=$page&pageSize=$pageSize';
    if (status.isNotEmpty) url += '&status=$status';
    if (customerId != null) url += '&customerId=$customerId';
    if (driverId != null) url += '&driverId=$driverId';
    if (storeIds != null) url += '&storeIds=$storeIds';
    if (filters != null) url += '&filters=$filters';
    if (type != null) url += '&type=$type';

    var result = await request(
      requestType: RequestType.get,
      path: url,
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          List<Order> order = [];
          order = List<Order>.from(
            response['data']['items'].map((e) => Order.fromJson(e)),
          );

          return Success(
            Pagination.fromJson({
              'totalData': response['data']['totalItems'],
              'totalPages': response['data']['totalPages'],
              'data': order,
            }),
          );
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<Order, String>> getOrder({required num id}) async {
    String url = '/Order/Get?id=$id';

    var result = await request(
      requestType: RequestType.get,
      path: url,
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          return Success(Order.fromJson(response['data']));
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<String, String>> applyLoyaltyPoints({required num orderId, required num points}) async {
    String url = '/Order/ApplyLoyaltyPoints?orderId=$orderId&points=$points';

    var result = await request(
      requestType: RequestType.post,
      path: url,
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          return Success(response['message']);
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<String, String>> setOrderStatus({required num orderId, required String status, String? reason}) async {
    String url = '/Order/SetStatus?orderId=$orderId&status=$status';
    if (reason != null) {
      url += '&reason=$reason';
    }

    var result = await request(
      requestType: RequestType.post,
      path: url,
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          return Success(response['message']);
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<String, String>> updateDriverLocation({required LocationDto location}) async {
    String url = '/Order/UpdateDriverLocation';
    url += '?driverLatitude=${location.latitude}&driverLongitude=${location.longitude}';

    Preferences.shared = await SharedPreferences.getInstance();
    String? token = preferences.getUserProfile()?.token;

    var result = await request(
      requestType: RequestType.post,
      path: url,
      headers: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          return Success(response['message']);
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<String, String>> saveOrder({required Order item}) async {
    String url = '/Order/Save';

    var result = await request(
      requestType: RequestType.post,
      path: url,
      data: item.toJson(),
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          return Success(response['message']);
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<String, String>> setOrderType({required num orderId, required String orderType}) async {
    String url = '/Order/SetOrderType?orderId=$orderId&orderType=$orderType';

    var result = await request(
      requestType: RequestType.post,
      path: url,
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          return Success(response['message']);
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<String, String>> preCheckout({
    required num tip,
    required DateTime tipscheduleDate,
    required String orderType,
    // required num frontLicenceFileId,
    // required num backLicenseFileId,
  }) async {
    String url = '/Order/PreCheckout';

    var result = await request(
      requestType: RequestType.post,
      path: url,
      data: {
        'tip': tip,
        'scheduleDate': '${tipscheduleDate.toUtc()}'.replaceAll(' ', 'T'),
        'orderType': orderType,
        // 'frontLicenceFileId': frontLicenceFileId,
        // 'backLicenseFileId': backLicenseFileId,
      },
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          return Success(response['message']);
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }
}
