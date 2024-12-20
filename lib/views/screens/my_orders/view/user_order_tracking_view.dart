import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/model/order.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:alcoholdeliver/views/screens/my_orders/provider/user_order_tracking_provider.dart';
import 'package:alcoholdeliver/views/screens/my_orders/widgets/agent_card.dart';
import 'package:alcoholdeliver/views/screens/my_orders/widgets/order_items_list.dart';
import 'package:alcoholdeliver/views/screens/my_orders/widgets/order_summary.dart';
import 'package:alcoholdeliver/views/widgets/app_bar/back_app_bar.dart';
import 'package:alcoholdeliver/views/widgets/bottom_nav_bar/seconday_bottom_nav_bar.dart';
import 'package:alcoholdeliver/views/widgets/common_widgets.dart';
import 'package:alcoholdeliver/views/widgets/google_map_direction.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:alcoholdeliver/views/widgets/scrollable_column.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserOrderTrackingView extends StatefulWidget {
  final Order order;

  const UserOrderTrackingView({super.key, required this.order});

  @override
  State<UserOrderTrackingView> createState() => _UserOrderTrackingViewState();
}

class _UserOrderTrackingViewState extends State<UserOrderTrackingView> {
  late UserOrderTrackingProvider provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getOrder(context, widget.order.id ?? 0);
      provider.initListener(widget.order.firebaseItemId ?? '');
      provider.getEstimatedTime(
          widget.order.originCoordinate, widget.order.destinationCoordinate);
    });
  }

  @override
  void dispose() {
    provider.cDispose();
    provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(context, title: 'Delivery Tracking'),
      body: Consumer(builder: (context, ref, _) {
        provider = ref.watch(userOrderTrackingProvider);

        return ScrollableColumn.withSafeArea(
          padding: EdgeInsets.zero,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Sizes.s300.h,
              child: provider.isMapLoading
                  ? Loader.circularProgressIndicator()
                  : GoogleMapDirection(
                      originName: '',
                      hideOriginMarker: provider.isLocationAvailable,
                      originCoordinates: provider.originCoordinate,
                      destinationName: '',
                      destinationCoordinates: provider.destinationCoordinate,
                      externalMarkers: provider.driverLocation,
                    ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: PaddingValues.padding.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Traking Informations
                  SizedBoxH20(),
                  Text(
                    'Tracking Details',
                    style: TextStyle(
                      color: AppColors.primaryFontColor,
                      fontWeight: FontWeight.w500,
                      fontSize: Sizes.s20.sp,
                    ),
                  ),
                  SizedBoxH20(),
                  ColumnText(
                    label: 'Delivery Time',
                    value: provider.isEstimatedTimeLoading
                        ? 'Loading..'
                        : provider.deliveryEstimatedTime == null
                            ? 'N/A'
                            : provider.deliveryEstimatedTime!,
                  ),
                  SizedBoxH20(),

                  ColumnText(
                      label: 'Delivery Address',
                      value: '#${widget.order.address ?? 'N/A'}'),
                  SizedBoxH20(),

                  Text(
                    'Order ID: #${widget.order.id ?? 'N/A'}',
                    style: TextStyle(
                      color: AppColors.primaryFontColor,
                      fontWeight: FontWeight.w400,
                      fontSize: Sizes.s16.sp,
                    ),
                  ),
                  SizedBoxH10(),

                  OrderItemsList(items: provider.order?.orderItems ?? []),
                  SizedBoxH20(),

                  OrderSummary(order: widget.order),
                  SizedBoxH20(),

                  /// Driver Information
                  AgentCard(
                    name: widget.order.driverName ?? 'N/A',
                    type: 'Delivery Agent',
                    onTapChat: () {
                      Navigator.of(context)
                          .pushNamed(Routes.chat, arguments: widget.order);
                    },
                  ),
                  SizedBoxH30(),

                  /// Order Status
                  /// TODO: Implement Order Status UI
                  // const BlueDivider(),
                  // SizedBoxH10(),
                  // const BlueDivider(),
                  // SizedBoxH10(),

                  /// Action Buttons
                  // Consumer(builder: (context, ref, _) {
                  //   final provider = ref.watch(homepageProvider);

                  //   return PrimaryButton(
                  //     label: 'Cancel Order',
                  //     showShadow: true,
                  //     onPressed: () async {
                  //       final status = await provider.setOrderStatus(context, widget.order.id ?? 0, 'Cancelled');
                  //       if (!status) return;

                  //       provider.reloadDeliveryOrders();
                  //       // ignore: use_build_context_synchronously
                  //       Navigator.of(context).pop();
                  //     },
                  //   );
                  // }),
                  // SizedBoxH30(),
                ],
              ),
            )
          ],
        );
      }),
      bottomNavigationBar: const SecondaryBottomNavBar(),
    );
  }
}
