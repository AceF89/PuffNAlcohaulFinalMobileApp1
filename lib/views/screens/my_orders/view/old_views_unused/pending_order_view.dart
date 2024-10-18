import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/views/screens/my_orders/provider/old_views_unused/pending_order_provider.dart';
import 'package:alcoholdeliver/views/screens/my_orders/widgets/myorders_tab_card.dart';
import 'package:alcoholdeliver/views/widgets/common_widgets.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:alcoholdeliver/views/widgets/scrollable_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PendingOrderView extends StatefulWidget {
  const PendingOrderView({super.key});

  @override
  State<PendingOrderView> createState() => _PendingOrderViewState();
}

class _PendingOrderViewState extends State<PendingOrderView> {
  late PendingOrdersProvider _provider;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.getAllPendingOrders();

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
    return Expanded(
      child: Consumer(
        builder: (context, ref, _) {
          _provider = ref.watch(pendingOrdersProvider);

          if (_provider.loading) {
            return Loader.circularProgressIndicator();
          }

          if (_provider.orders.isEmpty) {
            return RefreshIndicator(
              onRefresh: _provider.refreshPage,
              child: ScrollableColumn(
                controller: _scrollController,
                crossAxisAlignment: CrossAxisAlignment.start,
                physics:
                    _provider.loading ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
                children: const [NoDataAvailable(height: Sizes.s300)],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _provider.refreshPage,
            child: ScrollableColumn(
              controller: _scrollController,
              crossAxisAlignment: CrossAxisAlignment.start,
              padding: EdgeInsets.zero,
              physics: _provider.loading ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
              children: [
                ListView.builder(
                  itemCount: _provider.orders.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    final curOrder = _provider.orders[index];

                    return MyOrdersTabCard(order: curOrder);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
