import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/views/widgets/common_widgets.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';

class CheckoutOptionsOrderInfo extends StatelessWidget {
  const CheckoutOptionsOrderInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Checkout',
          style: TextStyle(
            fontSize: Sizes.s18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBoxH10(),
        const _InfoLabelText(label: 'Service Fee', value: '\$5.00'),
        SizedBoxH10(),
        const _InfoLabelText(label: 'Sub Total', value: '\$441.00'),
        SizedBoxH10(),
        const _InfoLabelText(label: 'Driver\'s Tip', value: '\$5.00'),
        SizedBoxH10(),
        const _InfoLabelText(label: 'Tax', value: '\$4.00'),
        SizedBoxH10(),
        const BlueDivider(),
        SizedBoxH10(),
        const _InfoLabelText(label: 'Total', value: '\$450.00'),
        SizedBoxH10(),
        const BlueDivider(),
        SizedBoxH10(),
      ],
    );
  }
}

class _InfoLabelText extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLabelText({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Sizes.s16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: Sizes.s16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
