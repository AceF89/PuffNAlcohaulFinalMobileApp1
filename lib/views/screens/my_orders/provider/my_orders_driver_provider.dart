import 'package:alcoholdeliver/providers/default_change_notifier.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AutoDisposeChangeNotifierProvider<MyOrdersDriverProvider> myOrdersDriverProvider =
    ChangeNotifierProvider.autoDispose((ref) => MyOrdersDriverProvider());

class MyOrdersDriverProvider extends DefaultChangeNotifier {
  int? selectedTabIndex = 1;
  final Map<int, String> tabs = {1: 'On Delivery', 2: 'Delivered'};
  // final Map<int, String> tabs = {1: 'On Delivery', 2: 'Pending', 3: 'Delivered'};

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  MyOrdersDriverProvider();

  void setSelectedTab(int index) {
    selectedTabIndex = index;
    notify();
  }
}
