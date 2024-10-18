import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/views/screens/my_orders/provider/my_orders_driver_provider.dart';
import 'package:alcoholdeliver/views/screens/my_orders/provider/my_orders_provider.dart';
import 'package:alcoholdeliver/views/screens/my_orders/view/current_order_view.dart';
import 'package:alcoholdeliver/views/screens/my_orders/view/driver_delivered_view.dart';
import 'package:alcoholdeliver/views/screens/my_orders/view/driver_delivery_view.dart';
import 'package:alcoholdeliver/views/screens/my_orders/view/past_order_view.dart';
import 'package:alcoholdeliver/views/screens/my_orders/widgets/my_orders_tabs.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: preferences.isUser ? const UserMyOrdersScreen() : const DriverMyOrdersScreen(),
    );
  }
}

class UserMyOrdersScreen extends StatelessWidget {
  const UserMyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late MyOrdersProvider provider;

    return Consumer(
      builder: (context, ref, _) {
        provider = ref.watch(myOrdersProvider);

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.s20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                SizedBoxH20(),
                Text(
                  'My Orders',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: Sizes.s20.sp,
                    color: AppColors.primaryFontColor,
                  ),
                ),
                SizedBoxH30(),

                /// Tabs
                MyOrdersTabs(
                  selectedTab: provider.selectedTab,
                  onChange: provider.changeTab,
                ),

                // const AllOrderView(),

                /// Tabs View
                SizedBoxH20(),
                if (provider.selectedTab == MyOrderTabs.currentOrder) const CurrentOrderView(),
                if (provider.selectedTab == MyOrderTabs.pastOrder) const PastOrderView(),
                // if (provider.selectedTab == MyOrderTabs.preparing) const PreparingOrderView(),
                // if (provider.selectedTab == MyOrderTabs.pickup) const PickupOrderView(),
                // if (provider.selectedTab == MyOrderTabs.delivered) const DeliveredOrderView(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DriverMyOrdersScreen extends StatelessWidget {
  const DriverMyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late MyOrdersDriverProvider provider;

    return Consumer(
      builder: (context, ref, _) {
        provider = ref.watch(myOrdersDriverProvider);

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              SizedBoxH20(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.s20),
                child: Text(
                  'My Orders',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: Sizes.s20.sp,
                    color: AppColors.primaryFontColor,
                  ),
                ),
              ),
              SizedBoxH20(),

              /// Tabs
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  initialIndex: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TabBar(
                        labelStyle: TextStyle(
                          fontSize: Sizes.s18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        onTap: (i) => provider.setSelectedTab(i),
                        indicatorSize: TabBarIndicatorSize.tab,
                        unselectedLabelColor: AppColors.secondaryFontColor,
                        tabs: const [
                          // Tab(text: 'Pending'),
                          Tab(text: 'On Delivery'),
                          Tab(text: 'Delivered'),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Expanded(
                        child: TabBarView(
                          children: [
                            // DriverPendingView(),
                            DriverDeliveryView(),
                            DriverDeliveredView(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // if (provider.selectedTab == MyOrderTabs.pickup) const PickupOrderView(),
              // if (provider.selectedTab == MyOrderTabs.delivered) const DeliveredOrderView(),
            ],
          ),
        );
      },
    );
  }
}
