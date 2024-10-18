import 'package:alcoholdeliver/apis/product_api/product_api.dart';
import 'package:alcoholdeliver/model/product.dart';
import 'package:alcoholdeliver/providers/default_change_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AutoDisposeChangeNotifierProvider<ProductDetailsProvider>
    productDetailsProvider =
    ChangeNotifierProvider.autoDispose((ref) => ProductDetailsProvider());

class ProductDetailsProvider extends DefaultChangeNotifier {
  List<Product> relateableProducts = [];
  final ProductApi _productApi = ProductApi.instance;

  ProductDetailsProvider();

  Future<void> getAllProduct(num catId) async {
    try {
      loading = true;
      var result = await _productApi.getAllProduct(
        page: 1,
        type: GetAllProductE.byCategory,
        catId: catId,
      );

      return result.when(
        (value) async {
          relateableProducts = value.data ?? [];
          loading = false;
          notify();
        },
        (error) {
          loading = false;
        },
      );
    } finally {
      loading = false;
    }
  }
}
