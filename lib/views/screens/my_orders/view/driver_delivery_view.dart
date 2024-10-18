import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/views/screens/my_orders/provider/driver_delivery_provider.dart';
import 'package:alcoholdeliver/views/screens/my_orders/widgets/driver_delivery_card.dart';
import 'package:alcoholdeliver/views/widgets/common_widgets.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DriverDeliveryView extends StatefulWidget {
  const DriverDeliveryView({super.key});

  @override
  State<DriverDeliveryView> createState() => _DriverDeliveryViewState();
}

class _DriverDeliveryViewState extends State<DriverDeliveryView> {
  late DriverDeliveryProvider _provider;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.getAllOrders();

      _scrollController.addListener(() {
        setState(() {
          if (!_provider.loadMoreLoading) {
            if ((_scrollController.position.pixels == _scrollController.position.maxScrollExtent)) {
              _provider.loadMoreOrders();
            }
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      _provider = ref.watch(driverDeliveryProvider);

      return RefreshIndicator(
        onRefresh: _provider.refreshPage,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: PaddingValues.padding.h),
          child: _provider.loading
              ? Loader.circularProgressIndicator()
              : _provider.orders.isEmpty
                  ? const Center(child: NoDataAvailable())
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: _provider.orders.length,
                      itemBuilder: (ctx, index) {
                        final curOrder = _provider.orders[index];

                        return DriverDeliveryCard(orders: curOrder);
                      },
                    ),
        ),
      );
    });
  }
}
