import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/model/add_to_card.dart';
import 'package:alcoholdeliver/providers/cart_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/model/product.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:alcoholdeliver/views/widgets/counter_card.dart';
import 'package:alcoholdeliver/views/widgets/image_view.dart';
import 'package:alcoholdeliver/views/widgets/primary_button.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  num quantity = 1;
  late CartProvider provider;

  bool get isProductAvailable => maxQtyAvailable <= 0;

  num get maxQtyAvailable =>
      ((widget.product.currentStock ?? 0) - provider.getQuantityWithZero(widget.product).toInt()).abs();

  Future<void> onTapQuickAdd() async {
    if (isProductAvailable) return;

    final newQuanity = provider.getQuantityWithZero(widget.product).toInt() + quantity;

    final status = await provider.addOrRemoveCart(
      context,
      AddToCart(
        productId: widget.product.id ?? 0,
        quantity: newQuanity,
        method: 'add',
      ),
    );
    if (!status) return;

    provider.addToCart(widget.product, newQuanity);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (ctx, ref, _) {
      provider = ref.watch(cartProvider);

      return GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            Routes.productDetails,
            arguments: widget.product,
          );
        },
        child: Container(
          height: Sizes.s200.h,
          width: Sizes.s200.w,
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
                imageUrl: widget.product.productImageFullUrl,
                height: Sizes.s120.h,
                width: double.infinity,
                radius: BorderRadius.only(
                  topLeft: Radius.circular(Sizes.s20.sp),
                  topRight: Radius.circular(Sizes.s20.sp),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Sizes.s8.sp,
                  horizontal: Sizes.s12.sp,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Sizes.s30.sp,
                      width: double.infinity,
                      child: AutoSizeText(
                        widget.product.name ?? 'N/A',
                        textAlign: TextAlign.start,
                        maxFontSize: Sizes.s14.sp,
                        minFontSize: Sizes.s8.sp,
                        maxLines: 2,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '\$${widget.product.formattedSalePrice}',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: Sizes.s14.sp,
                        color: AppColors.secondaryFontColor,
                      ),
                    ),
                    Column(
                      children: [
                        SizedBoxH10(),
                        CounterCard(
                          maxLessValue: 0,
                          maxValue: maxQtyAvailable,
                          disableButtonsOnMaxValue: true,
                          onChange: (int value) => quantity = value,
                          initialCounter: !isProductAvailable ? 1 : 0,
                        ),
                        Center(
                          child: PrimaryButton(
                            padding: EdgeInsets.zero,
                            height: Sizes.s30,
                            width: Sizes.s100,
                            borderRadius: Sizes.s6,
                            label: 'Quick Add',
                            color: isProductAvailable ? AppColors.iconColor : AppColors.primaryColor,
                            onPressed: onTapQuickAdd,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
