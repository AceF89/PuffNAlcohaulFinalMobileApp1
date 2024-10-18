import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/utils/screen_util.dart';
import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget? child;

  const AppBackground({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.black,
          height: ScreenUtil().screenHeight,
          child: Column(
            children: [
              Image.asset(
                AppAssets.screenBackgroung,
                filterQuality: FilterQuality.high,
                width: double.infinity,
                height: Sizes.s240.h,
                fit: BoxFit.fill,
              ),
            ],
          ),
        ),
        Positioned(
          top: Sizes.s240.h - Sizes.s30,
          left: 0,
          right: 0,
          child: Container(
            height: ScreenUtil().screenHeight - Sizes.s240.h - Sizes.s30,
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Sizes.s40.sp),
                topRight: Radius.circular(Sizes.s40.sp),
              ),
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}
