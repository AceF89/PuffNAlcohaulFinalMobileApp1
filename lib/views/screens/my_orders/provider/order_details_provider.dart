import 'package:alcoholdeliver/apis/order_api/order_api.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/model/order.dart';
import 'package:alcoholdeliver/providers/default_change_notifier.dart';
import 'package:alcoholdeliver/services/connectivity_service.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AutoDisposeChangeNotifierProvider<OrderDetailsProvider> orderDetailsProvider =
    ChangeNotifierProvider.autoDispose((ref) => OrderDetailsProvider());

class OrderDetailsProvider extends DefaultChangeNotifier {
  Order? order;
  final OrderApi _api = OrderApi.instance;

  OrderDetailsProvider();

  Future<void> getOrder(BuildContext context, num id) async {
    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);
      var result = await _api.getOrder(id: id);

      return result.when(
        (value) async {
          order = value;
          notify();
          Loader.dismiss(context);
        },
        (error) {
          context.showFailureSnackBar(error);
          Loader.dismiss(context);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
    }
  }
}
