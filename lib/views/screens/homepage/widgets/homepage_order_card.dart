import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/model/order.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:alcoholdeliver/views/widgets/image_view.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class HomepageOrderCard extends StatelessWidget {
  final Order data;

  const HomepageOrderCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(Routes.orderTracking, arguments: data);
      },
      child: Container(
        width: Sizes.s200.w,
        height: Sizes.s250.h,
        margin: const EdgeInsets.only(
          right: Sizes.s20,
          bottom: Sizes.s10,
          top: Sizes.s10,
        ),
        decoration: BoxDecoration(
          color: AppColors.lightBackgroundColor,
          border: Border.all(
            width: 1,
            color: AppColors.borderColor,
          ),
          borderRadius: BorderRadius.circular(Sizes.s20.sp),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            ImageView(
              imageUrl: data.productImageFullUrl,
              height: Sizes.s100.h,
              width: double.infinity,
              radius: BorderRadius.only(
                topLeft: Radius.circular(Sizes.s20.sp),
                topRight: Radius.circular(Sizes.s20.sp),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Sizes.s8.sp,
                  horizontal: Sizes.s12.sp,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Row(),
                    SizedBox(
                      width: Sizes.s180.w,
                      child: AutoSizeText(
                        data.productName ?? 'N/A',
                        textAlign: TextAlign.start,
                        maxFontSize: Sizes.s20.sp,
                        minFontSize: Sizes.s14.sp,
                        maxLines: 2,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      'Order ID: #${data.id ?? 'N/A'}',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: Sizes.s14.sp,
                        color: AppColors.secondaryFontColor,
                      ),
                    ),
                    Text(
                      '\$${data.total ?? 'N/A'}',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: Sizes.s14.sp,
                        color: AppColors.secondaryFontColor,
                      ),
                    ),
                    Text(
                      data.statusDisplay ?? 'N/A',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: Sizes.s14.sp,
                        color: AppColors.secondaryFontColor,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
