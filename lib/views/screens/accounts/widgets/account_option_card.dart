import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountOptionCard extends StatelessWidget {
  final String label;
  final String icon;
  final VoidCallback? onTap;

  const AccountOptionCard({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Sizes.s20.sp),
        decoration: BoxDecoration(
          color: AppColors.secondaryFontColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(Sizes.s10.sp),
        ),
        child: Row(
          children: [
            SvgPicture.asset(icon),
            SizedBoxW20(),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: Sizes.s16.sp,
              ),
            ),
            const Spacer(),
            SvgPicture.asset(
              AppAssets.icForwardLight,
              height: Sizes.s20.h,
              width: Sizes.s20.w,
            ),
          ],
        ),
      ),
    );
  }
}
