import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/model/order.dart';
import 'package:alcoholdeliver/views/screens/my_orders/view/user_order_tracking_view.dart';
import 'package:alcoholdeliver/views/screens/my_orders/view/vendor_order_tracking_view.dart';
import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatelessWidget {
  final Order order;

  const OrderTrackingScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return preferences.isDriver ? VendorOrderTrackingView(order: order) : UserOrderTrackingView(order: order);
  }
}
