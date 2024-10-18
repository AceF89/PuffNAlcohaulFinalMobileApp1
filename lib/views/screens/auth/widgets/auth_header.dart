import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_font_family.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String header;
  final String subHeader;

  const AuthHeader({
    super.key,
    required this.header,
    required this.subHeader,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          header,
          style: TextStyle(
            fontFamily: AppFontFamily.abrilFatface,
            fontSize: Sizes.s22.sp,
          ),
        ),
        SizedBoxH10(),
        Text(
          subHeader,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Sizes.s18.sp,
            color: AppColors.secondaryFontColor,
          ),
        ),
      ],
    );
  }
}
