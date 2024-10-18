import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/utils/screen_util.dart';
import 'package:alcoholdeliver/views/widgets/primary_button.dart';
import 'package:alcoholdeliver/views/widgets/primary_text_field.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RejectReasonDialog extends StatelessWidget {
  final TextEditingController controller;

  const RejectReasonDialog({super.key, required this.controller});

  static Future<String?> show(BuildContext context, TextEditingController controller) async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => RejectReasonDialog(controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: AppColors.whiteFontColor,
      backgroundColor: AppColors.whiteFontColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.s14.sp),
      ),
      content: SizedBox(
        width: ScreenUtil().screenWidth * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  'Reason',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Sizes.s18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context, controller.text.trim()),
                  child: SvgPicture.asset(
                    AppAssets.icCancel,
                    height: Sizes.s18.h,
                    width: Sizes.s18.w,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
            SizedBoxH30(),
            PrimaryTextField(
              hintText: '',
              controller: controller,
            ),
            SizedBoxH20(),
            PrimaryButton(
              label: 'Save',
              onPressed: () => Navigator.pop(context, controller.text.trim()),
            ),
          ],
        ),
      ),
    );
  }
}
