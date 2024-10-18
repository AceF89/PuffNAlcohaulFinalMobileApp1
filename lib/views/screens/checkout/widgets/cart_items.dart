import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/model/cart.dart';
import 'package:alcoholdeliver/views/widgets/counter_card.dart';
import 'package:alcoholdeliver/views/widgets/image_view.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CartItems extends StatelessWidget {
  final OrderItem product;
  final VoidCallback? onTapDelete;
  final ValueChanged<int> onChangeQuantity;
  final ValueChanged<int>? onIncrement;
  final ValueChanged<int>? onDecrement;

  const CartItems({
    super.key,
    required this.product,
    this.onTapDelete,
    required this.onChangeQuantity,
    this.onIncrement,
    this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Sizes.s20),
      child: Row(
        children: [
          ImageView(
            imageUrl: product.productImageFullUrl,
            height: Sizes.s100.h,
            width: Sizes.s100.w,
            radius: BorderRadius.circular(Sizes.s10.sp),
          ),
          SizedBoxW10(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        product.productName ?? 'N/A',
                        textAlign: TextAlign.start,
                        maxFontSize: Sizes.s14.sp,
                        minFontSize: Sizes.s10.sp,
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Sizes.s18.sp,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onTapDelete,
                      child: SvgPicture.asset(
                        AppAssets.icBin,
                        height: Sizes.s20.h,
                        width: Sizes.s20.w,
                      ),
                    ),
                  ],
                ),
                Text(
                  '\$${product.price}',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: Sizes.s16.sp,
                    color: AppColors.secondaryFontColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CounterCard(
                      initialCounter: product.quantity?.toInt() ?? 1,
                      onChange: onChangeQuantity,
                      maxValue: product.currentStock,
                      maxValueErrorMessage: 'No more product available',
                      onIncrement: onIncrement,
                      onDecrement: onDecrement,
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
