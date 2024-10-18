import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/model/product.dart';
import 'package:alcoholdeliver/views/screens/homepage/widgets/homepage_product_card.dart';
import 'package:alcoholdeliver/views/widgets/app_bar/back_app_bar.dart';
import 'package:alcoholdeliver/views/widgets/bottom_nav_bar/seconday_bottom_nav_bar.dart';
import 'package:alcoholdeliver/views/widgets/cart_action_button.dart';
import 'package:alcoholdeliver/views/widgets/common_widgets.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';

class FeatureProductScreen extends StatelessWidget {
  final List<Product> products;

  const FeatureProductScreen({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context,
        title: 'Featured Products',
        actions: [
          const CartActionButton(),
          SizedBoxW20(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: PaddingValues.padding),
        child: products.isEmpty
            ? const Center(child: NoDataAvailable())
            : GridView.builder(
                itemCount: products.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: Sizes.s20,
                  mainAxisSpacing: Sizes.s20,
                  mainAxisExtent: 220,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final curData = products[index];
                  return HomepageProductCard(data: curData);
                },
              ),
      ),
      bottomNavigationBar: const SecondaryBottomNavBar(),
    );
  }
}
