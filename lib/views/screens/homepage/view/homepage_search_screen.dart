import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/model/product.dart';
import 'package:alcoholdeliver/model/product_categories.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:alcoholdeliver/views/screens/homepage/provider/homepage_search_provider.dart';
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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class HomepageSearchScreen extends StatefulWidget {
  final List<ProductCategories> categories;

  const HomepageSearchScreen({super.key, required this.categories});

  @override
  State<HomepageSearchScreen> createState() => _HomepageSearchScreenState();
}

class _HomepageSearchScreenState extends State<HomepageSearchScreen> {
  late HomepageSearchProvider _provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: BackAppBar(
          context,
          title: 'Search',
          actions: [
            const CartActionButton(),
            SizedBoxW20(),
          ],
        ),
        body: Consumer(builder: (context, ref, _) {
          _provider = ref.watch(homepageSearchProvider);

          return ScrollableColumn.withSafeArea(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBoxH20(),
              TypeAheadField<Product>(
                suggestionsCallback: (search) {
                  if (search.isEmpty) return [];
                  return _provider.searchProduct(search);
                },
                builder: (context, controller, focusNode) {
                  return PrimaryTextField(
                    hintText: 'Search',
                    controller: controller,
                    focusNode: focusNode,
                    onChanged: (value) {
                      _provider.searchController.text = value;
                      _provider.onChangeSearch;
                    },
                    suffixIcon: Padding(
                      padding: EdgeInsets.all(Sizes.s12.sp),
                      child: SvgPicture.asset(
                        AppAssets.icSearch,
                        height: Sizes.s10.h,
                        width: Sizes.s10.w,
                      ),
                    ),
                  );
                },
                emptyBuilder: (context) {
                  return const SizedBox();
                },
                itemBuilder: (context, product) {
                  return ListTile(
                    visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
                    title: Text(
                      product.name ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      product.detail ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: Sizes.s14.sp,
                        color: AppColors.secondaryFontColor,
                      ),
                    ),
                  );
                },
                offset: const Offset(0, 12),
                constraints: BoxConstraints(maxHeight: Sizes.s300.h),
                onSelected: (product) {
                  Navigator.of(context).pushNamed(
                    Routes.productDetails,
                    arguments: product,
                  );
                },
              ),
              // PrimaryTextField(
              //   hintText: 'Search',
              //   controller: _provider.searchController,
              //   onChanged: _provider.onChangeSearch,
              //   suffixIcon: Padding(
              //     padding: EdgeInsets.all(Sizes.s12.sp),
              //     child: SvgPicture.asset(
              //       AppAssets.icSearch,
              //       height: Sizes.s10.h,
              //       width: Sizes.s10.w,
              //     ),
              //   ),
              // ),
              SizedBoxH20(),
              _provider.loading
                  ? Loader.circularProgressIndicator()
                  : _provider.searchController.text.isEmpty
                      ? const SizedBox()
                      : _provider.searchProducts.isEmpty
                          ? const Center(child: NoDataAvailable(height: Sizes.s100))
                          : GridView.builder(
                              itemCount: _provider.searchProducts.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: Sizes.s16,
                                mainAxisSpacing: Sizes.s14,
                                childAspectRatio: 0.62,
                                mainAxisExtent: Sizes.s280,
                              ),
                              itemBuilder: (context, index) {
                                final curProduct = _provider.searchProducts[index];

                                return ProductCard(product: curProduct);
                              },
                            ),
              // _provider.loading
              //     ? Loader.circularProgressIndicator()
              //     : _provider.searchController.text.isEmpty
              //         ? const SizedBox()
              //         : _provider.searchProducts.isEmpty
              //             ? const Center(child: NoDataAvailable(height: Sizes.s100))
              //             : SizedBox(
              //                 height: Sizes.s250.h,
              //                 width: double.infinity,
              //                 child: ListView.builder(
              //                   itemCount: _provider.searchProducts.length > 6 ? 6 : _provider.searchProducts.length,
              //                   shrinkWrap: true,
              //                   itemBuilder: (BuildContext context, int index) {
              //                     final curData = _provider.searchProducts[index];

              //                     return GestureDetector(
              //                       onTap: () {
              //                         Navigator.of(context).pushNamed(
              //                           Routes.productDetails,
              //                           arguments: curData,
              //                         );
              //                       },
              //                       child: Padding(
              //                         padding: const EdgeInsets.all(Sizes.s10),
              //                         child: Row(
              //                           children: [
              //                             SvgPicture.asset(AppAssets.icSearch),
              //                             SizedBoxW10(),
              //                             Expanded(
              //                               child: Text(curData.name ?? 'N/A'),
              //                             ),
              //                           ],
              //                         ),
              //                       ),
              //                     );
              //                   },
              //                 ),
              //               ),
              // const SearchHistoryBuilder(),
              // SizedBoxH20(),
              // Text(
              //   'Browse By Category',
              //   style: TextStyle(
              //     fontWeight: FontWeight.w600,
              //     fontFamily: AppFontFamily.abrilFatface,
              //     fontSize: Sizes.s18.sp,
              //   ),
              // ),
              // SizedBoxH10(),
              // SearchPageCategoryBuilder(categories: widget.categories),
            ],
          );
        }),
        bottomNavigationBar: const SecondaryBottomNavBar(),
        floatingActionButton: const CartFloatingBar(marginBottom: Sizes.s20),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
