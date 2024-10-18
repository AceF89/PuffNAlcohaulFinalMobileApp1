import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/utils/screen_util.dart';
import 'package:alcoholdeliver/views/widgets/primary_button.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeleteAddressDialog extends StatelessWidget {
  const DeleteAddressDialog({super.key});

  static Future<bool?> show(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const DeleteAddressDialog(),
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
                  'Confirmation',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Sizes.s18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
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
            Text(
              'Are You Sure You Want to Delete this Address?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Sizes.s16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBoxH20(),
            Text(
              'Once you delete your address, it cannot be undone.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Sizes.s12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.secondaryFontColor,
              ),
            ),
            SizedBoxH20(),
            PrimaryButton(
              label: 'Delete Address',
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      ),
    );
  }
}
