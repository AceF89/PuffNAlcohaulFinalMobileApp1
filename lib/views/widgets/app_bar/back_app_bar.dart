import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/views/screens/homepage/widgets/icon_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';

class BackAppBar extends PreferredSize {
  BackAppBar(
    BuildContext context, {
    String? title,
    VoidCallback? onTap,
    Color? backgroundColor,
    List<Widget>? actions,
    super.key,
  }) : super(
          preferredSize: Size.fromHeight(kToolbarHeight.h),
          child: AppBar(
            automaticallyImplyLeading: false,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: backgroundColor ?? Colors.transparent,
            centerTitle: false,
            leading: GestureDetector(
              onTap: onTap ?? () => Navigator.of(context).pop(),
              child: SizedBox(
                height: Sizes.s20.h,
                width: Sizes.s20.h,
                child: const Padding(
                  padding: EdgeInsets.only(
                    left: Sizes.s20,
                    top: Sizes.s10,
                    bottom: Sizes.s10,
                  ),
                  child: IconContainer(
                    icon: AppAssets.icBackArrow,
                  ),
                ),
              ),
            ),
            title: Text(
              title ?? '',
              maxLines: 2,
              style: TextStyle(
                color: AppColors.primaryFontColor,
                fontWeight: FontWeight.w600,
                fontSize: Sizes.s18.sp,
              ),
            ),
            actions: actions,
          ),
        );
}
