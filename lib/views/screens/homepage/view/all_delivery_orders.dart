import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/views/screens/homepage/provider/homepage_provider.dart';
import 'package:alcoholdeliver/views/screens/homepage/widgets/homepage_order_card.dart';
import 'package:alcoholdeliver/views/widgets/app_bar/back_app_bar.dart';
import 'package:alcoholdeliver/views/widgets/bottom_nav_bar/seconday_bottom_nav_bar.dart';
import 'package:alcoholdeliver/views/widgets/cart_action_button.dart';
import 'package:alcoholdeliver/views/widgets/common_widgets.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:alcoholdeliver/views/widgets/scrollable_column.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllDeliveryOrdersScreen extends StatefulWidget {
  const AllDeliveryOrdersScreen({super.key});

  @override
  State<AllDeliveryOrdersScreen> createState() => _AllDeliveryOrdersScreenState();
}

class _AllDeliveryOrdersScreenState extends State<AllDeliveryOrdersScreen> {
  late HomepageProvider _provider;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    return Scaffold(
      appBar: BackAppBar(
        context,
        title: 'Delivery Orders',
        actions: [
          const CartActionButton(),
          SizedBoxW20(),
        ],
      ),
      body: Consumer(builder: (context, ref, _) {
        _provider = ref.watch(homepageProvider);

        if (_provider.isLoadingDeliveryOrder) {
          return Loader.circularProgressIndicator();
        }

        if (_provider.orders.isEmpty) {
          return RefreshIndicator(
            onRefresh: _provider.refreshPage,
            child: ScrollableColumn(
              controller: _scrollController,
              crossAxisAlignment: CrossAxisAlignment.start,
              physics: _provider.loading ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
              children: const [NoDataAvailable(height: Sizes.s300)],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _provider.refreshPage,
          child: ScrollableColumn(
            controller: _scrollController,
            crossAxisAlignment: CrossAxisAlignment.start,
            physics: _provider.loading ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
            children: [
              GridView.builder(
                itemCount: _provider.orders.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: Sizes.s20,
                  mainAxisSpacing: Sizes.s20,
                  mainAxisExtent: 220,
                ),
                itemBuilder: (context, index) {
                  final curOrder = _provider.orders[index];

                  return HomepageOrderCard(data: curOrder);
                },
              ),
              SizedBoxH20(),
            ],
          ),
        );
      }),
      bottomNavigationBar: const SecondaryBottomNavBar(),
    );
  }
}
