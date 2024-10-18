part of 'categories_api.dart';

abstract class CategoriesApiService extends ClientService implements CategoriesApi {}

class _CategoriesApiImpl extends CategoriesApiService {
  @override
  Future<Result<List<ProductCategories>, String>> getAllCategories({num? storeId}) async {
    String path = '/Categories/GetAll?pageNumber=1&pageSize=100';

    if (storeId != null) {
      path += '&storeId=$storeId';
    }

    var result = await request(requestType: RequestType.get, path: path);

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          List<ProductCategories> categories = [];
          categories = List<ProductCategories>.from(
            response['data']['items'].map((e) => ProductCategories.fromJson(e)),
          );

          return Success(categories);
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }
}
