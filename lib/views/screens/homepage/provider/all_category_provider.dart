import 'package:alcoholdeliver/model/product_categories.dart';
import 'package:alcoholdeliver/providers/default_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AutoDisposeChangeNotifierProvider<AllCategoryProvider> allCategoryProvider =
    ChangeNotifierProvider.autoDispose((ref) => AllCategoryProvider());

class AllCategoryProvider extends DefaultChangeNotifier {
  final List<ProductCategories> catgories = [];
  final List<ProductCategories> searchedCatgories = [];
  final TextEditingController searchController = TextEditingController();

  AllCategoryProvider();

  void setupCategoris(List<ProductCategories> cat) {
    catgories.clear();
    catgories.addAll(cat);
    searchedCatgories.clear();
    searchedCatgories.addAll(cat);
    notify();
  }

  void onChangeSearch(String value) {
    if (value.isEmpty) {
      searchedCatgories.clear();
      searchedCatgories.addAll(catgories);
    } else {
      final filteredCat =
          catgories.where((e) => (e.name?.toLowerCase().startsWith(value.toLowerCase()) ?? false)).toList();
      searchedCatgories.clear();
      searchedCatgories.addAll(filteredCat);
    }
    notify();
  }
}
