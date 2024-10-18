import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/views/screens/homepage/widgets/icon_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';

class CenterAppBar extends PreferredSize {
  CenterAppBar(
    BuildContext context, {
    String? title,
    VoidCallback? onTap,
    bool canBack = true,
    Color? backgroundColor,
    List<Widget>? actions,
    super.key,
  }) : super(
          preferredSize: Size.fromHeight(kToolbarHeight.h),
          child: AppBar(
            automaticallyImplyLeading: false,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: backgroundColor ?? Colors.transparent,
            centerTitle: true,
            leading: canBack
                ? GestureDetector(
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
                          icon: AppAssets.icBackArrowBlack,
                          borderWidth: 0,
                          borderColor: Colors.transparent,
                        ),
                      ),
                    ),
                  )
                : null,
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
