import 'package:alcoholdeliver/model/pagination_response.dart';
import 'package:alcoholdeliver/model/store.dart';
import 'package:alcoholdeliver/services/client/client_service.dart';
import 'package:alcoholdeliver/services/client/result.dart';

part 'store_api_impl.dart';

abstract class StoreApi {
  static final StoreApi _instance = _StoreApiImpl();

  static StoreApi get instance => _instance;

  Future<Result<Pagination<List<Store>>, String>> getAllStores({
    required int page,
    required num userId,
  });

  Future<Result<bool, String>> getNearbyStore({
    String? filters,
    required num radius,
    required num storeId,
  });
}
