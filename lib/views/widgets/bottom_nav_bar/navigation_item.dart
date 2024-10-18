import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NavigationItem extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final Color selectedLabelColor;
  final Color iconColor;
  final Color selectedIconColor;
  final Color labelColor;
  final bool isSelected;
  final VoidCallback? onTap;
  final String? assetName;

  const NavigationItem({
    super.key,
    this.icon,
    this.label,
    required this.isSelected,
    this.iconColor = Colors.white,
    this.labelColor = Colors.white,
    this.selectedIconColor = AppColors.accentColor,
    this.selectedLabelColor = AppColors.accentColor,
    this.onTap,
    this.assetName,
  });

  @override
  Widget build(BuildContext context) {
    bool isAssetIcon = assetName != null;
    bool isSvgAsset =
        isAssetIcon ? assetName?.endsWith('.svg') ?? false : false;
    bool needSafeArea = MediaQuery.of(context).viewPadding.bottom != 0;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Sizes.s4.h,
            vertical: Sizes.s10.h,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(Sizes.s100),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isAssetIcon
                  ? isSvgAsset
                      ? SvgPicture.asset(
                          assetName ?? '',
                          height: Sizes.s24.sp,
                          colorFilter: ColorFilter.mode(
                            isSelected ? selectedIconColor : iconColor,
                            BlendMode.srcIn,
                          ),
                        )
                      : Image.asset(
                          assetName ?? '',
                          height: Sizes.s30.sp,
                        )
                  : Icon(
                      icon,
                      color: isSelected ? selectedIconColor : iconColor,
                    ),
              if (!isAssetIcon) SizedBoxH10(),
              if (isAssetIcon) const SizedBox(height: 4),
              if (label != null && isSelected) SizedBoxW05(),
              if (label != null && isSelected)
                Text(
                  label!,
                  style: TextStyle(
                    fontSize: Sizes.s12.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? selectedLabelColor : labelColor,
                  ),
                ),
              if (needSafeArea) SizedBoxH15(),
            ],
          ),
        ),
      ),
    );
  }
}
