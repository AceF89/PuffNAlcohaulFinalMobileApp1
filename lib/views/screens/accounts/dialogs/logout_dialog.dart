import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/utils/screen_util.dart';
import 'package:alcoholdeliver/views/widgets/primary_button.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  static Future<bool?> show(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LogoutDialog(),
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
            Container(
              height: Sizes.s50,
              width: Sizes.s50,
              padding: EdgeInsets.all(Sizes.s8.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(Sizes.s200.sp),
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.icLogout,
                  height: Sizes.s22,
                  width: Sizes.s22,
                ),
              ),
            ),
            SizedBoxH20(),
            Text(
              'Are You Sure You want  to Logout?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Sizes.s18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBoxH20(),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    label: 'Logout',
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ),
                SizedBoxW10(),
                Expanded(
                  child: PrimaryButton(
                    label: 'Cancel',
                    color: AppColors.borderColor,
                    textColor: AppColors.secondaryFontColor,
                    onPressed: () => Navigator.pop(context, false),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
