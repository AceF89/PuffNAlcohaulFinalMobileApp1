import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_font_family.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/model/charge_card_res.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:alcoholdeliver/views/screens/checkout/widgets/info_label_text.dart';
import 'package:alcoholdeliver/views/widgets/app_bar/back_app_bar.dart';
import 'package:alcoholdeliver/views/widgets/primary_button.dart';
import 'package:alcoholdeliver/views/widgets/scrollable_column.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final ChargeCardRes data;

  const PaymentSuccessScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context,
        title: 'Payment Success',
        onTap: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.mainHome,
            (Route<dynamic> route) => false,
          );
        },
      ),
      body: ScrollableColumn.withSafeArea(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBoxH20(),
          SvgPicture.asset(AppAssets.icSuccessCheck),
          SizedBoxH20(),
          Text(
            'Payment Successful!',
            style: TextStyle(
              fontFamily: AppFontFamily.abrilFatface,
              fontSize: Sizes.s20.sp,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBoxH20(),
          Container(
            padding: EdgeInsets.all(Sizes.s10.sp),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Sizes.s10.sp),
              color: AppColors.primaryColor.withOpacity(0.1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoLabelText(label: 'Order ID', value: data.id?.toString() ?? 'N/A'),
                SizedBoxH10(),
                InfoLabelText(label: 'Date', value: data.formatDate),
                SizedBoxH10(),
                InfoLabelText(label: 'Time', value: data.formatTimeCentral),
                SizedBoxH10(),
                const InfoLabelText(label: 'Payment Method', value: 'Credit Card'),
                SizedBoxH10(),
                InfoLabelText(label: 'Amount', value: '\$${data.total?.toStringAsFixed(2) ?? 'N/A'}'),
              ],
            ),
          ),
          SizedBoxH30(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Sizes.s10.sp),
          child: PrimaryButton.outlined(
            label: "Back to Home",
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.mainHome,
                (Route<dynamic> route) => false,
              );
            },
          ),
        ),
      ),
    );
  }
}
