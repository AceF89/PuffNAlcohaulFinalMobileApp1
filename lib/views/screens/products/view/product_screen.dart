import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/model/product_categories.dart';
import 'package:alcoholdeliver/views/screens/products/provider/product_provider.dart';
import 'package:alcoholdeliver/views/screens/products/widgets/product_card.dart';
import 'package:alcoholdeliver/views/widgets/app_bar/back_app_bar.dart';
import 'package:alcoholdeliver/views/widgets/bottom_nav_bar/seconday_bottom_nav_bar.dart';
import 'package:alcoholdeliver/views/widgets/cart_action_button.dart';
import 'package:alcoholdeliver/views/widgets/cart_floating_bar.dart';
import 'package:alcoholdeliver/views/widgets/common_widgets.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:alcoholdeliver/views/widgets/primary_text_field.dart';
import 'package:alcoholdeliver/views/widgets/scrollable_column.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductScreen extends StatefulWidget {
  final ProductCategories categorie;

  const ProductScreen({super.key, required this.categorie});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late ProductProvider _provider;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.setup(widget.categorie.id ?? 0);
      _provider.getAllProductByCategory();

      _scrollController.addListener(() {
        setState(() {
          if (!_provider.loadMoreLoading) {
            if ((_scrollController.position.pixels == _scrollController.position.maxScrollExtent)) {
              _provider.loadMoreEvents();
            }
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context,
        title: widget.categorie.name ?? 'N/A',
        actions: [
          const CartActionButton(),
          SizedBoxW20(),
        ],
      ),
      body: Consumer(
        builder: (context, ref, _) {
          _provider = ref.watch(productProvider);

          return ScrollableColumn(
            controller: _scrollController,
            physics: _provider.loading ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
            children: [
              PrimaryTextField(
                hintText: 'Search Product',
                controller: _provider.searchController,
                onChanged: _provider.onChangeSearch,
              ),
              SizedBoxH20(),
              if (_provider.loading) Loader.circularProgressIndicator(),
              if (!_provider.loading && _provider.product.isEmpty) const Center(child: NoDataAvailable()),
              GridView.builder(
                shrinkWrap: true,
                itemCount: _provider.product.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: Sizes.s16,
                  mainAxisSpacing: Sizes.s14,
                  childAspectRatio: 0.62,
                  mainAxisExtent: Sizes.s280,
                ),
                itemBuilder: (context, index) {
                  final curProduct = _provider.product[index];

                  return ProductCard(product: curProduct);
                },
              ),
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
