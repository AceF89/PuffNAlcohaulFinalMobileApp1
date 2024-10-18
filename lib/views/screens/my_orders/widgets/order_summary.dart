import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/model/order.dart';
import 'package:alcoholdeliver/views/widgets/common_widgets.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';

class OrderSummary extends StatelessWidget {
  final Order? order;

  const OrderSummary({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bill Details',
          style: TextStyle(
            color: AppColors.primaryFontColor,
            fontWeight: FontWeight.w600,
            fontSize: Sizes.s16.sp,
          ),
        ),
        SizedBoxH10(),
        if (order?.type != 'PICKUP') ...[
          _buildColumnLabels('Delivery Fee', order?.deliveryFee),
          SizedBoxH10(),
          _buildColumnLabels('Service Fee', order?.serviceFeeC),
          SizedBoxH10(),
        ],
        _buildColumnLabels('Sub Total', order?.subTotal?.toStringAsFixed(2)),
        SizedBoxH10(),
        _buildColumnLabels('Driver\'s Tip', order?.tip?.toStringAsFixed(2)),
        SizedBoxH10(),
        _buildColumnLabels('Tax', order?.totalTax?.toStringAsFixed(2)),
        SizedBoxH10(),
        const BuildDivider(),
        // SizedBoxH10(),
        // _buildColumnLabels('Paid Via', 'Stripe'),
        SizedBoxH10(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Bill',
              style: TextStyle(
                color: AppColors.secondaryFontColor,
                fontWeight: FontWeight.w400,
                fontSize: Sizes.s16.sp,
              ),
            ),
            Text(
              '\$${order?.total?.toStringAsFixed(2)}',
              style: TextStyle(
                color: AppColors.primaryFontColor,
                fontWeight: FontWeight.w400,
                fontSize: Sizes.s16.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildColumnLabels(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.secondaryFontColor,
            fontWeight: FontWeight.w400,
            fontSize: Sizes.s16.sp,
          ),
        ),
        SizedBoxH5(),
        Text(
          value == null
              ? 'N/A'
              : value == 'Free' || value == 'Stripe'
                  ? value
                  : '\$$value',
          style: TextStyle(
            color: AppColors.primaryFontColor,
            fontWeight: FontWeight.w500,
            fontSize: Sizes.s16.sp,
          ),
        ),
      ],
    );
  }
}
