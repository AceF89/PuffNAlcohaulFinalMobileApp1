import 'package:alcoholdeliver/apis/product_api/product_api.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/model/product.dart';
import 'package:alcoholdeliver/providers/default_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AutoDisposeChangeNotifierProvider<ProductProvider> productProvider =
    ChangeNotifierProvider.autoDispose((ref) => ProductProvider());

class ProductProvider extends DefaultChangeNotifier {
  final ProductApi _productApi = ProductApi.instance;

  int _pageNumber = 1;
  num _totalResult = 0;
  List<Product> product = [];
  bool loadMoreLoading = false;
  num catId = 0;

  final TextEditingController searchController = TextEditingController();

  ProductProvider();

  void setup(num id) {
    catId = id;
  }

  void onChangeSearch(String n) {
    product.clear();
    getAllProductByCategory();
    notify();
  }

  set setLoadMoreLoading(bool value) {
    loadMoreLoading = value;
    notify();
  }

  Future<void> loadMoreEvents() async {
    if (_totalResult != product.length) {
      var result = await getAllProductByCategory(
        isLoadMore: true,
      );
      if (result.isNotEmpty) {
        product.addAll(result);
        notify();
      }
    }
  }

  Future<List<Product>> getAllProductByCategory({
    bool isLoadMore = false,
  }) async {
    try {
      if (isLoadMore) {
        _pageNumber++;
        setLoadMoreLoading = true;
      } else {
        loading = true;
      }

      final type = searchController.text.trim().isEmpty ? GetAllProductE.byCategory : GetAllProductE.searchByCategory;

      var result = await _productApi.getAllProduct(
        page: _pageNumber,
        type: type,
        catId: catId,
        searchTerm: searchController.text.trim(),
        storeId: preferences.getUserProfile()?.storeId ?? 1,
      );

      return result.when(
        (value) async {
          _totalResult = value.totalData;
          if (!isLoadMore) product = value.data ?? [];
          return value.data ?? [];
        },
        (error) {
          product = [];
          return [];
        },
      );
    } finally {
      isLoadMore ? setLoadMoreLoading = false : loading = false;
    }
  }
}
