import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/utils/utils.dart';
import 'package:alcoholdeliver/model/user_address.dart';
import 'package:alcoholdeliver/views/screens/homepage/widgets/icon_containers.dart';
import 'package:alcoholdeliver/views/screens/my_address/widgett/rounded_container.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AddressCard extends StatelessWidget {
  final VoidCallback onTap;
  final UserAddress address;
  final VoidCallback onTapDelete;
  final VoidCallback onTapEdit;

  const AddressCard({
    super.key,
    required this.onTap,
    required this.address,
    required this.onTapDelete,
    required this.onTapEdit,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: Sizes.s14),
      bgColor: (address.isDefault ?? false)
          ? AppColors.accentColor.withOpacity(0.1)
          : AppColors.backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Home location
          SvgPicture.asset(
            AppAssets.icHome2,
            height: Sizes.s26,
            width: Sizes.s26,
          ),
          SizedBoxW10(),

          /// Address Section
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   address.name ?? 'N/A',
                //   style: TextStyle(
                //     fontSize: Sizes.s14.sp,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
                // SizedBoxH5(),
                Text(
                  address.address2 != null && address.address2!.isNotEmpty
                      ? "${Utils.getDisplayAddress(address.address, address.googleAddress, address.address2)} ${address.zipcode}"
                      : '${address.googleAddress} ${address.zipcode}',
                  style: TextStyle(
                    fontSize: Sizes.s12.sp,
                  ),
                ),
                SizedBoxH5(),
                Text(
                  'Phone number: ${address.phoneNumber ?? 'N/A'}',
                  style: TextStyle(fontSize: Sizes.s12.sp),
                ),
                SizedBoxH10(),
                Row(
                  children: [
                    IconContainer(
                      onTap: onTapDelete,
                      width: Sizes.s20.sp,
                      height: Sizes.s20.sp,
                      icon: AppAssets.icBin,
                      iconWidth: Sizes.s4.sp,
                      iconHeight: Sizes.s4.sp,
                      padding: EdgeInsets.all(Sizes.s3.sp),
                      colorFilter: const ColorFilter.mode(
                          AppColors.primaryColor, BlendMode.srcIn),
                    ),
                    SizedBoxW10(),
                    IconContainer(
                      onTap: onTapEdit,
                      width: Sizes.s20.sp,
                      height: Sizes.s20.sp,
                      iconWidth: Sizes.s4.sp,
                      iconHeight: Sizes.s4.sp,
                      icon: AppAssets.icEdit,
                      padding: EdgeInsets.all(Sizes.s4.sp),
                    ),
                    SizedBoxW10(),
                    IconContainer(
                      width: Sizes.s20.sp,
                      height: Sizes.s20.sp,
                      iconWidth: Sizes.s4.sp,
                      iconHeight: Sizes.s4.sp,
                      icon: AppAssets.icShare,
                      padding: EdgeInsets.all(Sizes.s2.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
