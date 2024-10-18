import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class TipCard extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const TipCard({
    super.key,
    this.isSelected = false,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Sizes.s45.h,
        width: Sizes.s45.w,
        margin: const EdgeInsets.only(right: Sizes.s20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : AppColors.whiteFontColor,
          border: isSelected
              ? null
              : Border.all(
                  width: 1,
                  color: AppColors.primaryFontColor,
                ),
          borderRadius: BorderRadius.circular(Sizes.s10),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: Sizes.s16.sp,
              color: isSelected
                  ? AppColors.whiteFontColor
                  : AppColors.secondaryFontColor,
            ),
          ),
        ),
      ),
    );
  }
}
