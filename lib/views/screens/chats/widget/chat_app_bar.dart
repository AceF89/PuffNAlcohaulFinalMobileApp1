import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget {
  final String customerName;
  final String driverName;
  final bool isDriver;

  const ChatAppBar({
    super.key,
    required this.customerName,
    required this.driverName,
    required this.isDriver,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ImageView(
        //   imageUrl:
        //       'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=2960&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        //   height: Sizes.s40.sp,
        //   width: Sizes.s40.sp,
        //   radius: BorderRadius.all(
        //     Radius.circular(Sizes.s200.sp),
        //   ),
        // ),
        // SizedBoxW10(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isDriver ? customerName : driverName,
              style: TextStyle(
                color: AppColors.primaryFontColor,
                fontSize: Sizes.s16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            // Text(
            //   'Active Now',
            //   style: TextStyle(
            //     color: AppColors.secondaryFontColor,
            //     fontSize: Sizes.s12.sp,
            //     fontWeight: FontWeight.w400,
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}
