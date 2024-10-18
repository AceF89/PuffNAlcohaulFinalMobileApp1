import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/model/order.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:alcoholdeliver/views/widgets/image_view.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyOrdersTabCard extends StatelessWidget {
  final Order order;

  const MyOrdersTabCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(Routes.orderDetails, arguments: order);
      },
      child: Container(
        padding: EdgeInsets.all(Sizes.s10.sp),
        margin: EdgeInsets.only(bottom: Sizes.s20.sp),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: AppColors.borderColor,
          ),
          borderRadius: BorderRadius.circular(Sizes.s10.sp),
        ),
        child: Column(
          children: [
            Row(
              children: [
                ImageView(
                  imageUrl: order.productImageFullUrl,
                  height: Sizes.s80.h,
                  width: Sizes.s80.w,
                  radius: BorderRadius.circular(Sizes.s10.sp),
                ),
                SizedBoxW10(),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              order.productName ?? 'N/A',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: Sizes.s14.sp,
                              ),
                            ),
                          ),
                          Text(
                            '\$${order.total}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Sizes.s14.sp,
                              color: AppColors.secondaryFontColor,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Order Id: #${order.id}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: Sizes.s12.sp,
                          color: AppColors.secondaryFontColor,
                        ),
                      ),
                      // SizedBoxH5(),
                      Text(
                        (order.address?.isEmpty ?? false)
                            ? 'N/A'
                            : order.address ?? 'N/A',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: Sizes.s12.sp,
                          color: AppColors.secondaryFontColor,
                        ),
                      ),
                      SizedBoxH5(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppAssets.icCheckCircle,
                          ),
                          SizedBoxW05(),
                          Text(
                            order.statusDisplay ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: Sizes.s12.sp,
                              color: AppColors.quaternaryFontColor,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            order.formatedDate ?? 'N/A',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Sizes.s12.sp,
                              color: AppColors.secondaryFontColor,
                            ),
                          ),
                        ],
                      ),
                    ],
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
