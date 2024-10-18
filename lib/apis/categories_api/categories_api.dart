import 'package:alcoholdeliver/model/product_categories.dart';
import 'package:alcoholdeliver/services/client/client_service.dart';
import 'package:alcoholdeliver/services/client/result.dart';
part 'categories_api_impl.dart';

abstract class CategoriesApi {
  static final CategoriesApi _instance = _CategoriesApiImpl();

  static CategoriesApi get instance => _instance;

  Future<Result<List<ProductCategories>, String>> getAllCategories({num? storeId});
}
