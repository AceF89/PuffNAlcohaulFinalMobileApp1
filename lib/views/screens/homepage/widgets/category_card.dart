import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/views/screens/homepage/widgets/icon_containers.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CategoryCard extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Sizes.s8.sp),
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
            IconContainer(
              icon: icon,
              fillColor: AppColors.primaryColor,
            ),
            SizedBoxW10(),
            SizedBox(
              width: Sizes.s80.w,
              child: AutoSizeText(
                label,
                textAlign: TextAlign.start,
                maxFontSize: Sizes.s14.sp,
                minFontSize: Sizes.s12.sp,
                wrapWords: false,
                maxLines: 2,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
