import 'dart:io';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/views/widgets/image_view.dart';
import 'package:alcoholdeliver/views/widgets/primary_button.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';

class LicenseCard extends StatelessWidget {
  final String label;
  final File? selectedImage;
  final String? selectedImageUrl;
  final VoidCallback onTap;
  final bool showBottomText;
  final bool showButton;
  final String buttonLabel;
  final bool ignorePointer;

  const LicenseCard({
    super.key,
    required this.onTap,
    required this.label,
    this.selectedImage,
    this.selectedImageUrl,
    this.showBottomText = true,
    this.showButton = false,
    this.ignorePointer = false,
    this.buttonLabel = 'N/A',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (ignorePointer) return;
        onTap.call();
      },
      child: Column(
        children: [
          if (selectedImage != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(Sizes.s10),
              child: Image.file(
                selectedImage!,
                filterQuality: FilterQuality.high,
                height: Sizes.s100.h,
                width: Sizes.s100.w,
                fit: BoxFit.cover,
              ),
            ),
          ],
          if (selectedImage == null && selectedImageUrl == null) ...[
            Container(
              height: Sizes.s100.h,
              width: Sizes.s100.w,
              decoration: BoxDecoration(
                color: AppColors.secondaryFontColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(Sizes.s10.sp),
              ),
              child: const Center(child: Text('+')),
            ),
          ],
          if (selectedImageUrl != null && selectedImage == null) ...[
            ImageView(
              imageUrl: selectedImageUrl!,
              height: Sizes.s100.h,
              width: Sizes.s100.w,
              radius: BorderRadius.circular(Sizes.s10),
            ),
          ],
          if (showBottomText) ...[
            SizedBoxH5(),
            Text(label),
          ],
          if (showButton) ...[
            PrimaryButton(
              width: Sizes.s100.w,
              height: Sizes.s30.h,
              fontSize: Sizes.s14.sp,
              label: buttonLabel,
              onPressed: onTap,
            ),
          ],
        ],
      ),
    );
  }
}
