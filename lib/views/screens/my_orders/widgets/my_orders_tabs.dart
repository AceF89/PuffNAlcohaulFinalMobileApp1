import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/views/screens/my_orders/provider/my_orders_provider.dart';
import 'package:alcoholdeliver/views/widgets/primary_button.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';

class MyOrdersTabs extends StatelessWidget {
  final MyOrderTabs selectedTab;
  final Function(MyOrderTabs n) onChange;

  const MyOrdersTabs({
    super.key,
    required this.selectedTab,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: Sizes.s45.h,
      child: Row(
        children: [
          Expanded(
            child: PrimaryButton(
              label: 'Current Order',
              // width: Sizes.s120.sp,
              color: selectedTab == MyOrderTabs.currentOrder
                  ? AppColors.primaryColor
                  : AppColors.primaryColor.withOpacity(0.1),
              textColor: selectedTab == MyOrderTabs.currentOrder ? null : AppColors.secondaryFontColor,
              labelWeight: FontWeight.w400,
              onPressed: () => onChange(MyOrderTabs.currentOrder),
            ),
          ),
          SizedBoxW20(),
          Expanded(
            child: PrimaryButton(
              label: 'Past Order',
              // width: Sizes.s120.sp,
              color: selectedTab == MyOrderTabs.pastOrder
                  ? AppColors.primaryColor
                  : AppColors.primaryColor.withOpacity(0.1),
              textColor: selectedTab == MyOrderTabs.pastOrder ? null : AppColors.secondaryFontColor,
              labelWeight: FontWeight.w400,
              onPressed: () => onChange(MyOrderTabs.pastOrder),
            ),
          ),
        ],
      ),
      // child: ListView(
      //   shrinkWrap: true,
      //   scrollDirection: Axis.horizontal,
      //   children: [],
      // ),
    );
  }
}
