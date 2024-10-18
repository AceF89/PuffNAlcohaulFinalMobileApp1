import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/model/order.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';

class OrderItemsList extends StatelessWidget {
  final List<OrderItem> items;

  const OrderItemsList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Order',
          style: TextStyle(
            color: AppColors.primaryFontColor,
            fontWeight: FontWeight.w600,
            fontSize: Sizes.s16.sp,
          ),
        ),
        SizedBoxH10(),
        ListView.builder(
          shrinkWrap: true,
          itemCount: items.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, i) {
            final curOrder = items[i];

            return Container(
              padding: const EdgeInsets.all(Sizes.s10),
              margin: const EdgeInsets.only(bottom: Sizes.s10),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: AppColors.secondaryFontColor,
                ),
                borderRadius: BorderRadius.circular(Sizes.s10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          curOrder.productName ?? 'N/A',
                          style: TextStyle(
                            color: AppColors.primaryFontColor,
                            fontWeight: FontWeight.w600,
                            fontSize: Sizes.s16.sp,
                          ),
                        ),
                        SizedBoxH5(),
                        Text(
                          '${curOrder.quantity} x ${curOrder.price?.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: AppColors.primaryFontColor,
                            fontWeight: FontWeight.w600,
                            fontSize: Sizes.s16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: Sizes.s6,
                      horizontal: Sizes.s10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: AppColors.secondaryFontColor,
                      ),
                      borderRadius: BorderRadius.circular(Sizes.s12),
                    ),
                    child: Text(
                      '\$${((curOrder.price ?? 0) * (curOrder.quantity ?? 1)).toStringAsFixed(2)}',
                      style: TextStyle(
                        color: AppColors.primaryFontColor,
                        fontWeight: FontWeight.w600,
                        fontSize: Sizes.s16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
