part of 'store_api.dart';

abstract class StoreApiService extends ClientService implements StoreApi {}

class _StoreApiImpl extends StoreApiService {
  @override
  Future<Result<Pagination<List<Store>>, String>> getAllStores({
    required int page,
    required num userId,
  }) async {
    String url = '/Stores/GetAll?pageNumber=$page&pageSize=100&userId=$userId';

    var result = await request(
      requestType: RequestType.get,
      path: url,
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          List<Store> store = [];
          store = List<Store>.from(
            response['data']['items'].map((e) => Store.fromJson(e)),
          );

          return Success(
            Pagination.fromJson({
              'totalData': response['data']['totalItems'],
              'totalPages': response['data']['totalPages'],
              'data': store,
            }),
          );
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<bool, String>> getNearbyStore({
    String? filters,
    required num radius,
    required num storeId,
  }) async {
    String url = '/Stores/GetNearbyStore?radius=$radius&storeId=$storeId';
    if (filters != null) url += '&filters=$filters';

    var result = await request(
      requestType: RequestType.get,
      path: url,
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          if (response['data'] == false) {
            return Success(false);
          }
          // Check if response['data'] is a List<dynamic>
          else if (response['data'] is List<dynamic>) {
            return Success(true);
          }
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }
}
