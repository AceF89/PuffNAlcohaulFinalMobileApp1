import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/views/widgets/image_view.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewOrderPlacedCard extends StatelessWidget {
  const NewOrderPlacedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Sizes.s8.sp),
      decoration: BoxDecoration(
        color: AppColors.lightBackgroundColor,
        border: Border.all(
          width: 1,
          color: AppColors.borderColor,
        ),
        borderRadius: BorderRadius.circular(Sizes.s10.sp),
      ),
      child: Row(
        children: [
          ImageView(
            imageUrl:
                'https://assets.architecturaldigest.in/photos/61127eb03ac224a1d5c7c7a9/4:3/w_2622,h_1967,c_limit/The%20right%20way%20to%20store%20wine%20at%20home%205.jpg',
            height: Sizes.s50.h,
            width: Sizes.s50.w,
            radius: BorderRadius.circular(Sizes.s10.sp),
          ),
          SizedBoxW10(),
          Text(
            'New Order Placed',
            style: TextStyle(
              fontSize: Sizes.s16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          SvgPicture.asset(
            AppAssets.icForwardArrow,
            height: Sizes.s24,
            width: Sizes.s24,
          ),
          SizedBoxW10(),
        ],
      ),
    );
  }
}
