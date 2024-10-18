import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';

class FreeServiceBanner extends StatelessWidget {
  final String label;

  const FreeServiceBanner({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBoxH10(),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(Sizes.s10.sp),
          decoration: BoxDecoration(
            color: AppColors.borderColor,
            borderRadius: BorderRadius.circular(Sizes.s10),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        SizedBoxH10(),
      ],
    );
  }
}
