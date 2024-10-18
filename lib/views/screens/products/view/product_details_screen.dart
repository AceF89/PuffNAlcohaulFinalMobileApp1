import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_font_family.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/model/add_to_card.dart';
import 'package:alcoholdeliver/model/product.dart';
import 'package:alcoholdeliver/providers/cart_provider.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:alcoholdeliver/views/screens/homepage/widgets/homepage_product_card.dart';
import 'package:alcoholdeliver/views/screens/products/provider/product_details_provider.dart';
import 'package:alcoholdeliver/views/widgets/app_bar/back_app_bar.dart';
import 'package:alcoholdeliver/views/widgets/bottom_nav_bar/seconday_bottom_nav_bar.dart';
import 'package:alcoholdeliver/views/widgets/cart_action_button.dart';
import 'package:alcoholdeliver/views/widgets/cart_floating_bar.dart';
import 'package:alcoholdeliver/views/widgets/common_widgets.dart';
import 'package:alcoholdeliver/views/widgets/counter_card.dart';
import 'package:alcoholdeliver/views/widgets/image_view.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:alcoholdeliver/views/widgets/primary_button.dart';
import 'package:alcoholdeliver/views/widgets/scrollable_column.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  num quantity = 1;
  late CartProvider _cartProvider;
  late ProductDetailsProvider provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getAllProduct(widget.product.catId ?? 0);
    });
  }

  bool get isProductAvailable => maxQtyAvailable <= 0;

  num get maxQtyAvailable =>
      ((widget.product.currentStock ?? 0) - _cartProvider.getQuantityWithZero(widget.product).toInt()).abs();

  void onTapAddToCart() async {
    if (isProductAvailable) return;

    final productId = widget.product.id?.toInt() ?? 0;
    final newQuanity = _cartProvider.getQuantityWithZero(widget.product).toInt() + quantity;

    final status = await _cartProvider.addOrRemoveCart(
      context,
      AddToCart(
        productId: productId,
        quantity: newQuanity,
        method: 'add',
      ),
    );

    if (!status) return;

    _cartProvider.updateQuantity(Product(id: productId), newQuanity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context,
        title: widget.product.name ?? 'N/A',
        actions: [
          const CartActionButton(),
          SizedBoxW20(),
        ],
      ),
      body: Consumer(
        builder: (context, ref, _) {
          provider = ref.watch(productDetailsProvider);
          _cartProvider = ref.watch(cartProvider);

          return ScrollableColumn.withSafeArea(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageView(
                imageUrl: widget.product.productImageFullUrl,
                height: Sizes.s200,
                width: double.infinity,
                radius: BorderRadius.circular(Sizes.s10),
              ),
              SizedBoxH10(),
              Text(
                widget.product.name ?? 'N/A',
                style: TextStyle(
                  fontFamily: AppFontFamily.abrilFatface,
                  fontWeight: FontWeight.w500,
                  fontSize: Sizes.s20.sp,
                ),
              ),
              SizedBoxH5(),
              Text(
                '\$${widget.product.formattedSalePrice}',
                style: TextStyle(
                  fontSize: Sizes.s18.sp,
                  color: AppColors.secondaryFontColor,
                ),
              ),
              SizedBoxH20(),
              Text(
                'Description',
                style: TextStyle(
                  fontSize: Sizes.s20.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBoxH5(),
              Text(
                widget.product.detail ?? 'N/A',
                style: TextStyle(
                  fontSize: Sizes.s16.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBoxH20(),
              SizedBoxH20(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Quantity',
                    style: TextStyle(
                      fontSize: Sizes.s18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  CounterCard(
                    maxLessValue: 0,
                    maxValue: maxQtyAvailable,
                    disableButtonsOnMaxValue: true,
                    onChange: (int value) => quantity = value,
                    initialCounter: !isProductAvailable ? 1 : 0,
                  )
                ],
              ),
              SizedBoxH10(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Max Qty Available: $maxQtyAvailable'),
                ],
              ),
              SizedBoxH30(),
              PrimaryButton.outlined(
                label: 'Add To Cart',
                onPressed: onTapAddToCart,
                textColor: isProductAvailable ? AppColors.iconColor : AppColors.primaryColor,
                outlinedColor: isProductAvailable ? AppColors.iconColor : AppColors.primaryColor,
              ),
              SizedBoxH20(),
              Divider(
                thickness: 1,
                color: AppColors.secondaryFontColor.withOpacity(0.3),
              ),
              SizedBoxH20(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Related Products',
                    style: TextStyle(
                      fontFamily: AppFontFamily.abrilFatface,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryFontColor,
                      fontSize: Sizes.s18.sp,
                    ),
                  ),
                  PrimaryTextButton(
                    label: 'View All',
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        Routes.allRelatedProducts,
                        arguments: provider.relateableProducts,
                      );
                    },
                  ),
                ],
              ),
              provider.loading
                  ? Loader.circularProgressIndicator()
                  : provider.relateableProducts.isEmpty
                      ? const Center(child: NoDataAvailable(height: Sizes.s100))
                      : SizedBox(
                          height: Sizes.s250.h,
                          child: ListView.builder(
                            itemCount: provider.relateableProducts.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              final curProd = provider.relateableProducts[index];
                              return HomepageProductCard(data: curProd);
                            },
                          ),
                        ),
              SizedBoxH50(),
              SizedBoxH30(),
            ],
          );
        },
      ),
      bottomNavigationBar: const SecondaryBottomNavBar(),
      floatingActionButton: const CartFloatingBar(marginBottom: Sizes.s20),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
