import 'package:alcoholdeliver/views/screens/my_orders/provider/driver_delivered_provider.dart';
import 'package:alcoholdeliver/views/screens/my_orders/widgets/driver_delivered_card.dart';
import 'package:alcoholdeliver/views/widgets/common_widgets.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:alcoholdeliver/views/widgets/scrollable_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DriverDeliveredView extends StatefulWidget {
  const DriverDeliveredView({super.key});

  @override
  State<DriverDeliveredView> createState() => _DriverDeliveredViewState();
}

class _DriverDeliveredViewState extends State<DriverDeliveredView> {
  late DriverDeliveredProvider _provider;
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
      _provider = ref.watch(driverDeliveredProvider);

      return RefreshIndicator(
        onRefresh: _provider.refreshPage,
        child: ScrollableColumn(
          controller: _scrollController,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _provider.loading
                ? Loader.circularProgressIndicator()
                : _provider.orders.isEmpty
                    ? const Center(child: NoDataAvailable())
                    : ListView.builder(
                        itemCount: _provider.orders.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, index) {
                          final curOrder = _provider.orders[index];

                          return DriverDeliveredCard(orders: curOrder);
                        },
                      ),
          ],
        ),
      );
    });
  }
}
