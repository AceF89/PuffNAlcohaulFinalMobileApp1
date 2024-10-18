import 'package:alcoholdeliver/apis/product_api/product_api.dart';
import 'package:alcoholdeliver/model/product.dart';
import 'package:alcoholdeliver/providers/default_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ChangeNotifierProvider<HomepageSearchProvider> homepageSearchProvider =
    ChangeNotifierProvider((ref) => HomepageSearchProvider());

class HomepageSearchProvider extends DefaultChangeNotifier {
  final ProductApi _productApi = ProductApi.instance;

  List<Product> searchProducts = [];
  final TextEditingController searchController = TextEditingController();

  HomepageSearchProvider();

  void clear() {
    searchController.clear();
    searchProducts.clear();
    notify();
  }

  void onChangeSearch(String n) {
    searchProducts.clear();
    searchProduct(n);
    notify();
  }

  Future<List<Product>> searchProduct(String search) async {
    loading = true;
    var result = await _productApi.getAllProduct(
      page: 1,
      type: GetAllProductE.search,
      searchTerm: search,
      // storeId: preferences.getUserProfile()?.storeId ?? 1,
    );

    return result.when(
      (value) async {
        searchProducts = value.data ?? [];
        loading = false;
        notify();
        return searchProducts;
      },
      (error) {
        loading = false;
        return [];
      },
    );
  }
}
