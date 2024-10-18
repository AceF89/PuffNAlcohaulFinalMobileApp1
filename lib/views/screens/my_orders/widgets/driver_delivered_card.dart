import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/model/order.dart';
import 'package:alcoholdeliver/views/widgets/image_view.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DriverDeliveredCard extends StatelessWidget {
  final Order orders;

  const DriverDeliveredCard({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Sizes.s20),
      padding: const EdgeInsets.all(Sizes.s8),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: AppColors.borderColor,
        ),
        borderRadius: BorderRadius.circular(Sizes.s10),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ImageView(
              imageUrl: orders.productImageFullUrl,
              height: Sizes.s70.h,
              width: Sizes.s70.w,
              radius: BorderRadius.circular(Sizes.s10.sp),
            ),
            SizedBoxW05(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        orders.placedByName ?? 'N/A',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: Sizes.s14.sp,
                        ),
                      ),
                      const DeliveredMark(),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Order No: #${orders.id}",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: Sizes.s14.sp,
                          color: AppColors.secondaryFontColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBoxH5(),
                  Text(
                    '#${orders.address}',
                    maxLines: 3,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: Sizes.s14.sp,
                      color: AppColors.secondaryFontColor,
                    ),
                  ),
                  SizedBoxH5(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${orders.total}',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: Sizes.s14.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const PaidMark(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeliveredMark extends StatelessWidget {
  const DeliveredMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          AppAssets.icCheckCircle,
          height: Sizes.s12,
          width: Sizes.s12,
        ),
        SizedBoxW05(),
        Text(
          'Delivered',
          style: TextStyle(
            color: AppColors.quaternaryFontColor,
            fontWeight: FontWeight.w400,
            fontSize: Sizes.s14.sp,
          ),
        ),
      ],
    );
  }
}

class PaidMark extends StatelessWidget {
  const PaidMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: Sizes.s6,
        horizontal: Sizes.s8,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Sizes.s4),
      ),
      child: Center(
        child: Text(
          'Paid',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w400,
            fontSize: Sizes.s14.sp,
          ),
        ),
      ),
    );
  }
}
