import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/model/order.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:alcoholdeliver/views/screens/my_orders/provider/order_details_provider.dart';
import 'package:alcoholdeliver/views/screens/my_orders/widgets/order_items_list.dart';
import 'package:alcoholdeliver/views/screens/my_orders/widgets/order_summary.dart';
import 'package:alcoholdeliver/views/widgets/app_bar/back_app_bar.dart';
import 'package:alcoholdeliver/views/widgets/bottom_nav_bar/seconday_bottom_nav_bar.dart';
import 'package:alcoholdeliver/views/widgets/cart_action_button.dart';
import 'package:alcoholdeliver/views/widgets/common_widgets.dart';
import 'package:alcoholdeliver/views/widgets/primary_button.dart';
import 'package:alcoholdeliver/views/widgets/scrollable_column.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Order order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late OrderDetailsProvider _provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.getOrder(context, widget.order.id ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context,
        title: 'Order Details',
        actions: [
          const CartActionButton(),
          SizedBoxW20(),
        ],
      ),
      body: Consumer(builder: (context, ref, _) {
        _provider = ref.watch(orderDetailsProvider);

        return ScrollableColumn.withSafeArea(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBoxH10(),
            ColumnText(label: 'Order ID', value: _provider.order?.id?.toString() ?? 'N/A'),
            SizedBoxH10(),
            ColumnText(label: 'Order Status', value: _provider.order?.statusDisplay ?? 'N/A'),
            SizedBoxH10(),
            if (_provider.order?.type != 'DELIVERY') ...[
              // ColumnText(label: 'Store Name', value: _provider.order?.storeName ?? 'N/A', showIcon: true),
              // SizedBoxH10(),
              ColumnText(label: 'Store Address', value: _provider.order?.storeAddress ?? 'N/A', showIcon: true),
              SizedBoxH10(),
            ],
            if (_provider.order?.status == 'DELIVERING') ...[
              SizedBoxH10(),
              PrimaryButton(
                label: 'Track Order',
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.orderTracking, arguments: _provider.order);
                },
              ),
              SizedBoxH10(),
            ],
            const BuildDivider(),
            SizedBoxH10(),
            OrderItemsList(items: _provider.order?.orderItems ?? []),
            SizedBoxH10(),
            const BuildDivider(),
            SizedBoxH10(),
            OrderSummary(order: _provider.order),
            SizedBoxH30(),
          ],
        );
      }),
      bottomNavigationBar: const SecondaryBottomNavBar(),
    );
  }
}

class ColumnText extends StatelessWidget {
  final String label;
  final String value;
  final bool showIcon;

  const ColumnText({
    super.key,
    required this.label,
    required this.value,
    this.showIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.primaryFontColor,
            fontWeight: FontWeight.w600,
            fontSize: Sizes.s16.sp,
          ),
        ),
        SizedBoxH5(),
        Row(
          children: [
            if (showIcon) ...[
              SvgPicture.asset(AppAssets.icLocation),
              SizedBoxW10(),
            ],
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: showIcon ? AppColors.secondaryFontColor : AppColors.primaryFontColor,
                  fontWeight: FontWeight.w400,
                  fontSize: Sizes.s16.sp,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
