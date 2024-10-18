import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';

class AccountInfoTile extends StatelessWidget {
  final String name;
  final String joinedDate;

  const AccountInfoTile({
    super.key,
    required this.name,
    required this.joinedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(
              name,
              style: TextStyle(
                color: AppColors.primaryFontColor,
                fontWeight: FontWeight.w600,
                fontSize: Sizes.s18.sp,
              ),
            ),
            SizedBoxH5(),
            Text(
              'Joined $joinedDate',
              style: TextStyle(
                color: AppColors.secondaryFontColor,
                fontWeight: FontWeight.w500,
                fontSize: Sizes.s16.sp,
              ),
            ),
          ],
        ),
        // IconContainer(
        //   icon: AppAssets.icEdit,
        //   fillColor: AppColors.borderColor,
        //   onTap: () {
        //     Navigator.of(context).pushNamed(Routes.editAccount);
        //   },
        // ),
      ],
    );
  }
}
