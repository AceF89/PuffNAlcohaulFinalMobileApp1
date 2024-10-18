import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/views/screens/my_address/widgett/rounded_container.dart';
import 'package:alcoholdeliver/views/widgets/primary_text_field.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatBottomBar extends StatelessWidget {
  final VoidCallback onTap;
  final TextEditingController controller;

  const ChatBottomBar({super.key, required this.onTap, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Sizes.s16),
      decoration: const BoxDecoration(
        color: AppColors.whiteFontColor,
      ),
      child: SafeArea(
        child: Row(
          children: [
            SizedBoxW10(),
            Expanded(
              child: PrimaryTextField(
                hintText: 'Write here...',
                controller: controller,
                suffixIcon: RoundedContainer(
                  bgColor: AppColors.primaryColor,
                  margin: EdgeInsets.all(Sizes.s2.sp),
                  child: GestureDetector(
                    onTap: onTap,
                    child: SvgPicture.asset(AppAssets.icSendChat),
                  ),
                ),
              ),
            ),
            SizedBoxW10(),
          ],
        ),
      ),
    );
  }
}
