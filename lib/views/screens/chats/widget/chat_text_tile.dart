import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/utils/screen_util.dart';
import 'package:alcoholdeliver/model/rc/rc_message.dart';
import 'package:flutter/material.dart';

class ChatTextTile extends StatelessWidget {
  final bool isLoggedInUser;
  final RcMessage message;

  const ChatTextTile({
    super.key,
    required this.isLoggedInUser,
    required this.message,
  });

  /*Widget _buildImageView() {
    return Container(
      height: Sizes.s30.sp,
      width: Sizes.s30.sp,
      decoration: BoxDecoration(
        color: isLoggedInUser ? AppColors.rightUserColor : AppColors.leftUserColor,
        borderRadius: BorderRadius.all(Radius.circular(Sizes.s200.sp)),
      ),
      child: Center(
        child: Text(
          message.userFullName?[0] ?? '',
        ),
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isLoggedInUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (!isLoggedInUser) ...[
        //   _buildImageView(),
        //   SizedBoxW10(),
        // ],
        Container(
          padding: const EdgeInsets.all(Sizes.s16),
          margin: const EdgeInsets.only(bottom: Sizes.s16),
          width: ScreenUtil().screenWidth * 0.6,
          decoration: BoxDecoration(
            color: isLoggedInUser ? AppColors.rightUserColor : AppColors.leftUserColor,
            border: Border.all(
              width: 1,
              color: AppColors.primaryBorderColor,
            ),
            borderRadius: BorderRadius.circular(Sizes.s6.sp),
          ),
          child: Text(message.msg ?? ''),
        ),
        // if (isLoggedInUser) ...[
        //   SizedBoxW10(),
        //   _buildImageView(),
        // ],
      ],
    );
  }
}
