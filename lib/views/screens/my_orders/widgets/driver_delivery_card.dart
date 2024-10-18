import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/model/order.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:alcoholdeliver/views/widgets/google_map_direction.dart';
import 'package:alcoholdeliver/views/widgets/image_view.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';

class DriverDeliveryCard extends StatelessWidget {
  final Order orders;

  const DriverDeliveryCard({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(Routes.orderTracking, arguments: orders);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: Sizes.s20),
        padding: const EdgeInsets.all(Sizes.s8),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: AppColors.borderColor,
          ),
          borderRadius: BorderRadius.circular(Sizes.s10),
        ),
        child: Column(
          children: [
            /// Order Info
            Row(
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
                          Text(
                            '\$${orders.total}',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: Sizes.s14.sp,
                              color: AppColors.primaryColor,
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
                    ],
                  ),
                ),
              ],
            ),
            SizedBoxH5(),
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
            // SizedBoxH5(),
            Row(
              children: [
                Text(
                  orders.orderType ?? 'N/A',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: Sizes.s14.sp,
                    color: AppColors.secondaryFontColor,
                  ),
                ),
              ],
            ),

            /// Google Maps
            SizedBoxH10(),
            SizedBox(
              height: Sizes.s200.h,
              child: GoogleMapDirection(
                originCoordinates: orders.originCoordinate,
                originName: '',
                destinationCoordinates: orders.destinationCoordinate,
                destinationName: '',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
