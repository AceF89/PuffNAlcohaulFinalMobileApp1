import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/views/screens/checkout/dialogs/loyalty_check_sheet.dart';
import 'package:alcoholdeliver/views/screens/checkout/widgets/info_label_text.dart';
import 'package:alcoholdeliver/views/widgets/common_widgets.dart';
import 'package:alcoholdeliver/views/widgets/primary_button.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';

class CheckoutOrderInfo extends StatelessWidget {
  final num productCost;
  final num subTotal;
  final num driverTip;
  final String serviceFee;
  final num taxes;
  final num total;
  final bool isPickupOrder;
  final num selectedPoints;
  final num totalWithLoyalty;
  final Function onChangeValue;
  final TextEditingController controller;

  const CheckoutOrderInfo({
    super.key,
    required this.productCost,
    required this.subTotal,
    required this.driverTip,
    required this.serviceFee,
    required this.taxes,
    required this.total,
    required this.controller,
    required this.totalWithLoyalty,
    required this.selectedPoints,
    required this.isPickupOrder,
    required this.onChangeValue,
  });

  String get _buildLoyaltyPoints {
    String points = controller.text;
    if (points.isEmpty) return '';

    num parsedPoint = num.parse(points);
    return parsedPoint.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Info',
          style: TextStyle(
            fontSize: Sizes.s18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBoxH10(),
        InfoLabelText(label: 'Sub Total', value: '\$${subTotal.toStringAsFixed(2)}'),
        SizedBoxH10(),
        if (!isPickupOrder) ...[
          const InfoLabelText(label: 'Delivery Fee', value: 'FREE'),
          SizedBoxH10(),
          InfoLabelText(label: 'Service Fee', value: serviceFee),
          SizedBoxH10(),
        ],
        InfoLabelText(label: 'Tips', value: '\$${driverTip.toStringAsFixed(2)}'),
        SizedBoxH10(),
        InfoLabelText(label: 'Taxes', value: '\$${taxes.toStringAsFixed(2)}'),
        SizedBoxH10(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Loyalty Points',
              style: TextStyle(
                fontSize: Sizes.s16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            if (selectedPoints > 0) ...[
              IconButton(
                onPressed: () {
                  onChangeValue(0);
                },
                icon: const Icon(Icons.clear),
              ),
              GestureDetector(
                onTap: () {
                  LoyaltyCheckSheet.show(context, controller, onChangeValue);
                },
                child: Text(
                  _buildLoyaltyPoints,
                  style: TextStyle(
                    fontSize: Sizes.s16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            if (selectedPoints <= 0)
              PrimaryButton(
                label: 'Check',
                width: Sizes.s40.w,
                height: Sizes.s20.h,
                fontSize: Sizes.s12.sp,
                borderRadius: Sizes.s4,
                onPressed: () {
                  LoyaltyCheckSheet.show(context, controller, onChangeValue);
                },
              ),
          ],
        ),
        SizedBoxH10(),
        const GreyDivider(),
        SizedBoxH10(),
        InfoLabelText(label: 'Total', value: '\$${total.toStringAsFixed(2)}'),
        SizedBoxH10(),
        InfoLabelText(label: 'Points Redeem', value: '\$${(selectedPoints / 100).toStringAsFixed(2)}'),
        SizedBoxH10(),
        InfoLabelTextWithBackround(label: 'Total amount payable', value: '\$${totalWithLoyalty.toStringAsFixed(2)}'),
        SizedBoxH10(),
        const GreyDivider(),
        SizedBoxH10(),
      ],
    );
  }
}
