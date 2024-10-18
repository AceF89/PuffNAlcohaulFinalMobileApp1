import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/views/widgets/app_bar/back_app_bar.dart';
import 'package:alcoholdeliver/views/widgets/bottom_nav_bar/seconday_bottom_nav_bar.dart';
import 'package:alcoholdeliver/views/widgets/scrollable_column.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';

class LoyaltyPointsScreen extends StatelessWidget {
  const LoyaltyPointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(context, title: 'My Loyalty Points'),
      body: ScrollableColumn.withSafeArea(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBoxH20(),
          Text(
            'How It Works?',
            style: TextStyle(
              fontSize: Sizes.s20.sp,
              color: AppColors.primaryFontColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBoxH10(),
          Padding(
            padding: const EdgeInsets.only(left: Sizes.s8),
            child: Text(
              r'1. For Every Dollar Spent on Liquor, You Earn 2 Loyalty Points!! You can redeem every 500 points for $5 to be used towards your next order!!',
              style: TextStyle(
                fontSize: Sizes.s15.sp,
                color: AppColors.primaryFontColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBoxH10(),
          Padding(
            padding: const EdgeInsets.only(left: Sizes.s8),
            child: Text(
              r'2. For Every Dollar Spent on Smoke and Vape Products. You Earn 5 Loyalty points!! You can redeem every 500 Points for $5 to be used towards your next order!!',
              style: TextStyle(
                fontSize: Sizes.s15.sp,
                color: AppColors.primaryFontColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // SizedBoxH20(),
          // const BuildDivider(),
          // SizedBoxH20(),
          // Row(
          //   children: [
          //     const ColorBackgroundText(
          //       text: '12,000',
          //       subtext: 'Total Earned Points',
          //     ),
          //     SizedBoxW10(),
          //     const ColorBackgroundText(
          //       text: '\$13,000',
          //       subtext: 'Total Purchase Points',
          //     ),
          //   ],
          // ),
          // SizedBoxH30(),
          // const ColumnText(
          //   text: 'Points Earned for Liquor',
          //   subtext: '8,000',
          // ),
          // SizedBoxH20(),
          // const ColumnText(
          //   text: 'Points Earned for Smoke',
          //   subtext: '4,000',
          // ),
        ],
      ),
      bottomNavigationBar: const SecondaryBottomNavBar(),
    );
  }
}

class ColorBackgroundText extends StatelessWidget {
  final String text;
  final String subtext;

  const ColorBackgroundText({
    super.key,
    required this.text,
    required this.subtext,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: Sizes.s100.h,
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(Sizes.s10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: Sizes.s20.sp,
                color: AppColors.primaryFontColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBoxH5(),
            Text(
              subtext,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Sizes.s14.sp,
                color: AppColors.primaryFontColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ColumnText extends StatelessWidget {
  final String text;
  final String subtext;

  const ColumnText({super.key, required this.text, required this.subtext});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: Sizes.s14.sp,
            color: AppColors.primaryFontColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBoxH5(),
        Text(
          subtext,
          style: TextStyle(
            fontSize: Sizes.s20.sp,
            color: AppColors.primaryFontColor,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
