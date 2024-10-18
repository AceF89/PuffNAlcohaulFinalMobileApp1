import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_font_family.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/model/snippets.dart';
import 'package:alcoholdeliver/views/widgets/image_view.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';

class CongratulationCard extends StatelessWidget {
  final String subMessage;
  final Snippets? snippet;

  const CongratulationCard({
    super.key,
    this.subMessage = 'You have earned \$5 on purchase of alcohol',
    this.snippet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Sizes.s8.sp,
        horizontal: Sizes.s12.sp,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        border: Border.all(
          width: 1,
          color: AppColors.borderColor,
        ),
        borderRadius: BorderRadius.circular(Sizes.s10.sp),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ImageView(
            imageUrl: snippet?.mediaFileFullUrl ?? '',
            height: Sizes.s100.h,
            width: Sizes.s100.w,
            radius: BorderRadius.circular(Sizes.s10),
          ),
          // SvgPicture.asset(
          //   AppAssets.icSpeaker,
          //   height: Sizes.s80,
          //   width: Sizes.s80,
          // ),
          SizedBoxW20(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  snippet?.content ?? 'N/A',
                  style: TextStyle(
                    fontFamily: AppFontFamily.abrilFatface,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                    fontSize: Sizes.s18.sp,
                  ),
                ),
                SizedBoxH5(),
                Text(
                  subMessage,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: Sizes.s14.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
