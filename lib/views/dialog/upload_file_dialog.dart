import 'dart:io';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/utils/file_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class UploadFileDialog extends StatelessWidget {
  final bool useGallery;

  const UploadFileDialog({
    super.key,
    this.useGallery = false,
  });

  static Future<File?> show(BuildContext context, {bool useGallery = false}) async {
    return showCupertinoDialog<File?>(
      context: context,
      barrierDismissible: true,
      builder: (context) => UploadFileDialog(useGallery: useGallery),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = const TextStyle(
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w500,
    );
    return CupertinoAlertDialog(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // SvgPicture.asset(AppAssets.uploadLine),
          SizedBox(height: Sizes.s12.h),
          Text(
            'Select Image for Upload',
            style: TextStyle(
              fontSize: Sizes.s18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          textStyle: textStyle,
          isDefaultAction: false,
          onPressed: () async {
            File? file;
            if (useGallery) {
              file = await FileUtils.pickImage(ImageSource.gallery);
            } else {
              file = await FileUtils.pickFile();
            }

            // ignore: use_build_context_synchronously
            Navigator.pop(context, file);
          },
          child: const Text('Choose photo from library'),
        ),
        CupertinoDialogAction(
          textStyle: textStyle,
          isDefaultAction: false,
          onPressed: () async {
            File? file = await FileUtils.pickImage(ImageSource.camera);
            // ignore: use_build_context_synchronously
            Navigator.pop(context, file);
          },
          child: const Text('Take Photo'),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          isDestructiveAction: true,
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
