import 'package:alcoholdeliver/providers/default_change_notifier.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MyOrderTabs { currentOrder, pastOrder }

final AutoDisposeChangeNotifierProvider<MyOrdersProvider> myOrdersProvider =
    ChangeNotifierProvider.autoDispose((ref) => MyOrdersProvider());

class MyOrdersProvider extends DefaultChangeNotifier {
  MyOrderTabs selectedTab = MyOrderTabs.currentOrder;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  MyOrdersProvider();

  void changeTab(MyOrderTabs n) {
    selectedTab = n;
    notify();
  }
}
