import 'dart:io';
import 'dart:ui';
import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/utils/screen_util.dart';
import 'package:alcoholdeliver/views/screens/homepage/widgets/icon_containers.dart';
import 'package:alcoholdeliver/views/widgets/image_view.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';

class AccountsBackground extends StatelessWidget {
  final String imageUrl;
  final String? backButtonLabel;
  final VoidCallback? onTapImage;
  final File? selectedImage;
  final Widget? child;

  // Widget Variables
  final double backgroundImageHeight = Sizes.s240;
  final double bufferBetweenElements = Sizes.s30;
  final double profileImageHeight = Sizes.s100;

  const AccountsBackground({
    super.key,
    this.child,
    this.backButtonLabel,
    required this.imageUrl,
    this.onTapImage,
    this.selectedImage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.black,
          height: ScreenUtil().screenHeight,
          child: Stack(
            children: [
              selectedImage != null
                  ? Image.file(
                      selectedImage!,
                      width: double.infinity,
                      filterQuality: FilterQuality.high,
                      height: backgroundImageHeight,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: backgroundImageHeight,
                      fit: BoxFit.cover,
                    ),
              ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    height: backgroundImageHeight,
                    color: Colors.black.withOpacity(0.2),
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: backgroundImageHeight - bufferBetweenElements,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.only(top: Sizes.s10.sp),
            height: ScreenUtil().screenHeight - backgroundImageHeight - bufferBetweenElements,
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
        Positioned(
          top: backgroundImageHeight - bufferBetweenElements - (profileImageHeight / 2),
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onTapImage,
                child: Container(
                  height: profileImageHeight,
                  width: profileImageHeight,
                  decoration: BoxDecoration(
                    color: AppColors.whiteFontColor,
                    border: Border.all(width: 4, color: AppColors.borderColor),
                    borderRadius: BorderRadius.circular(Sizes.s200.sp),
                  ),
                  child: Center(
                    child: ClipOval(
                      child: selectedImage != null
                          ? Image.file(
                              selectedImage!,
                              height: Sizes.s200.sp,
                              width: Sizes.s200.sp,
                              fit: BoxFit.cover,
                            )
                          : ImageView(
                              imageUrl: imageUrl,
                              width: Sizes.s100.sp,
                              height: Sizes.s100.sp,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (backButtonLabel != null)
          Positioned(
            top: Sizes.s20,
            left: Sizes.s20,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconContainer(
                  height: Sizes.s34,
                  width: Sizes.s34,
                  icon: AppAssets.icBackArrow,
                  borderColor: AppColors.borderColor.withOpacity(0.2),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  colorFilter: const ColorFilter.mode(
                    AppColors.whiteFontColor,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBoxW10(),
                Text(
                  backButtonLabel!,
                  style: TextStyle(
                    color: AppColors.whiteFontColor,
                    fontSize: Sizes.s18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
