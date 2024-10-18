import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/model/order.dart';
import 'package:alcoholdeliver/views/widgets/image_view.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:alcoholdeliver/views/widgets/toggle_button.dart';
import 'package:flutter/material.dart';

class DriverHomepageCard extends StatelessWidget {
  final Order orders;
  final Function? onToggle;

  const DriverHomepageCard({
    super.key,
    required this.orders,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key(orders.id.toString()),
      margin: const EdgeInsets.only(bottom: Sizes.s20),
      padding: const EdgeInsets.all(Sizes.s10),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: AppColors.borderColor,
        ),
        borderRadius: BorderRadius.circular(Sizes.s10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ImageView(
                imageUrl: orders.productImageFullUrl,
                height: Sizes.s50.h,
                width: Sizes.s50.w,
                radius: BorderRadius.circular(Sizes.s10.sp),
              ),
              SizedBoxW05(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          orders.placedByName ?? 'N/A',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: Sizes.s16.sp,
                          ),
                        ),
                        Text(
                          '\$${orders.total}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: Sizes.s16.sp,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBoxH5(),
                    Text(
                      '#${orders.address}',
                      maxLines: 3,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: Sizes.s14.sp,
                        color: AppColors.secondaryFontColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBoxH10(),
          Text(
            "Order No: #${orders.id}",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: Sizes.s14.sp,
              color: AppColors.secondaryFontColor,
            ),
          ),
          SizedBoxH10(),
          Text(
            orders.orderType ?? 'N/A',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: Sizes.s14.sp,
              color: AppColors.secondaryFontColor,
            ),
          ),
          SizedBoxH10(),
          Text(
            orders.displayValues ?? '',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: Sizes.s14.sp,
              color: AppColors.secondaryFontColor,
            ),
          ),
          SizedBoxH10(),
          ToggleButton(
            label: (orders.isDelivering ?? false)
                ? 'Out For Delivery'
                : 'Ready For Delivery',
            initialValue: (orders.isDelivering ?? false),
            onChanged: (bool n) => onToggle?.call(context, orders.id, n),
          ),
        ],
      ),
    );
  }
}
