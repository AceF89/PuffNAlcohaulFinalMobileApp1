import 'dart:async';

import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_font_family.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/model/google/location_result.dart';
import 'package:alcoholdeliver/providers/cart_provider.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:alcoholdeliver/services/location/location_service.dart';
import 'package:alcoholdeliver/views/screens/homepage/provider/driver_homepage_provider.dart';
import 'package:alcoholdeliver/views/screens/homepage/provider/homepage_provider.dart';
import 'package:alcoholdeliver/views/screens/homepage/widgets/category_card.dart';
import 'package:alcoholdeliver/views/screens/homepage/widgets/congratulation_card.dart';
import 'package:alcoholdeliver/views/screens/homepage/widgets/driver_homepage_card.dart';
import 'package:alcoholdeliver/views/screens/homepage/widgets/homepage_background.dart';
import 'package:alcoholdeliver/views/screens/homepage/widgets/homepage_header.dart';
import 'package:alcoholdeliver/views/screens/homepage/widgets/homepage_order_card.dart';
import 'package:alcoholdeliver/views/screens/homepage/widgets/homepage_product_card.dart';
import 'package:alcoholdeliver/views/widgets/cart_floating_bar.dart';
import 'package:alcoholdeliver/views/widgets/common_widgets.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:alcoholdeliver/views/widgets/primary_button.dart';
import 'package:alcoholdeliver/views/widgets/primary_text_field.dart';
import 'package:alcoholdeliver/views/widgets/scrollable_column.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

EdgeInsetsGeometry _kDefaultPadding =
EdgeInsets.symmetric(horizontal: PaddingValues.padding.h);

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  late HomepageProvider provider;
  late CartProvider _cartProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initOneSingle();
      if (preferences.isUser) _cartProvider.getCart(context);
      if (preferences.isUser) provider.getMe(context);
      if (preferences.isUser) provider.getDefaultAddress();
      if (preferences.isUser) provider.getAllDeliveryOrders();
      if (preferences.isUser) provider.getAllCategories(context);
      if (preferences.isUser) provider.getAllFeatureProduct(context);
      if (preferences.isUser) provider.getSnippets();
    });
  }



  Future<void> initOneSingle() async {
    // await OneSignal.Notifications.requestPermission(true);

    final playerId = await OneSignal.User.getOnesignalId();

    if (playerId != null) provider.setPlayerId(playerId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, _) {
          provider = ref.watch(homepageProvider);
          _cartProvider = ref.watch(cartProvider);

          return HomepageBackground(
            useBackground: preferences.isUser,
            child: RefreshIndicator(
              onRefresh: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (preferences.isUser) _cartProvider.getCart(context);
                  if (preferences.isUser) provider.getMe(context);
                  if (preferences.isUser) provider.getDefaultAddress();
                  if (preferences.isUser) provider.getAllDeliveryOrders();
                  if (preferences.isUser) provider.getAllCategories(context);
                  if (preferences.isUser) provider.getAllFeatureProduct(context);
                  if (preferences.isUser) provider.getSnippets();
                });
                return Future(() => true,);
              },
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: _kDefaultPadding,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBoxH5(),
                          if (preferences.isUser) const HomepageHeader(),
                          if (preferences.isDriver) const DriverHomepageHeader(),
                          SizedBoxH30(),
                          if (preferences.isUser)
                            Flexible(
                              fit: FlexFit.loose,
                              child: ScrollableColumn(
                                padding: EdgeInsets.zero,
                                children: [
                                  UserHomescreen(provider: provider),
                                ],
                              ),
                            ),
                          if (preferences.isDriver)
                            const Flexible(
                                fit: FlexFit.loose, child: DriverHomescreen()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: const CartFloatingBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class UserHomescreen extends StatefulWidget {
  final HomepageProvider provider;

  const UserHomescreen({super.key, required this.provider});

  @override
  State<UserHomescreen> createState() => _UserHomescreenState();
}

class _UserHomescreenState extends State<UserHomescreen> {
  late HomepageProvider _provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider = widget.provider;
      _provider.initListener();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.provider.snippets.isNotEmpty)
          CongratulationCard(
            snippet: widget.provider.snippets.first,
            subMessage:
            'You have ${preferences.getUserProfile()?.balanceloyaltyPoint} Loyalty Points',
          ),
        SizedBoxH30(),
        // const NewOrderPlacedCard(),
        // SizedBoxH20(),
        PrimaryTextField(
          hintText: 'Search',
          bWidth: 2,
          controller: TextEditingController(),
          readOnly: true,
          onTap: () {
            Navigator.of(context).pushNamed(
              Routes.homepageSearch,
              arguments: widget.provider.categories,
            );
          },
          suffixIcon: Padding(
            padding: EdgeInsets.all(Sizes.s10.sp),
            child: SvgPicture.asset(
              AppAssets.icSearch,
              height: Sizes.s10.h,
              width: Sizes.s10.w,
            ),
          ),
        ),

        if (widget.provider.orders.isNotEmpty) ...[
          SizedBoxH20(),
          _buildViewLabel('Delivery Orders', () {
            Navigator.of(context).pushNamed(Routes.allDeliveryOrdersScreen);
          }),
          widget.provider.isLoadingDeliveryOrder
              ? Loader.circularProgressIndicator()
              : widget.provider.orders.isEmpty
              ? const Center(child: NoDataAvailable(height: Sizes.s100))
              : SizedBox(
            height: Sizes.s240.h,
            width: double.infinity,
            child: ListView.builder(
              itemCount: widget.provider.orders.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                final curData = widget.provider.orders[index];
                return HomepageOrderCard(data: curData);
              },
            ),
          ),
        ],
        SizedBoxH20(),
        _buildViewLabel('Featured Products', () {
          Navigator.of(context).pushNamed(
            Routes.featureProducts,
            arguments: widget.provider.featuredProducts,
          );
        }),
        widget.provider.loading
            ? Loader.circularProgressIndicator()
            : widget.provider.featuredProducts.isEmpty
            ? const Center(child: NoDataAvailable(height: Sizes.s100))
            : SizedBox(
          height: Sizes.s200.h,
          width: double.infinity,
          child: ListView.builder(
            itemCount: widget.provider.featuredProducts.length,
            shrinkWrap: true,
            primary: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              final curData = widget.provider.featuredProducts[index];
              return HomepageProductCard(data: curData);
            },
          ),
        ),
        SizedBoxH20(),
        _buildViewLabel('Categories', () {
          Navigator.of(context).pushNamed(
            Routes.allCategories,
            arguments: widget.provider.categories,
          );
        }, hideViewAll: true),
        SizedBoxH10(),

        widget.provider.loading
            ? Loader.circularProgressIndicator()
            : widget.provider.categories.isEmpty
            ? const NoDataAvailable()
            : GridView.builder(
          itemCount: widget.provider.categories.length,
          // itemCount: provider.categories.length > 4 ? 4 : provider.categories.length,
          shrinkWrap: true,
          primary: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            crossAxisSpacing: Sizes.s20,
            mainAxisSpacing: Sizes.s20,
            mainAxisExtent: 60,
          ),
          itemBuilder: (context, index) {
            final curCategory = widget.provider.categories[index];

            return CategoryCard(
              label: curCategory.name ?? 'N/A',
              icon: curCategory.fullIconFileUrl ?? '',
              onTap: () {
                Navigator.of(context).pushNamed(
                  Routes.product,
                  arguments: curCategory,
                );
              },
            );
          },
        ),
        SizedBoxH40(),
      ],
    );
  }

  Widget _buildViewLabel(String label, VoidCallback onTap,
      {bool hideViewAll = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFontFamily.abrilFatface,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryFontColor,
            fontSize: Sizes.s18.sp,
          ),
        ),
        if (!hideViewAll)
          PrimaryTextButton(
            label: 'View All',
            onPressed: onTap,
          ),
      ],
    );
  }
}

class DriverHomescreen extends StatefulWidget {
  const DriverHomescreen({super.key});

  @override
  State<DriverHomescreen> createState() => _DriverHomescreenState();
}

class _DriverHomescreenState extends State<DriverHomescreen> {
  late DriverHomepageProvider _provider;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.initListener();
      _provider.getAllOrders();

      _scrollController.addListener(() {
        setState(() {
          if (!_provider.loadMoreLoading) {
            if ((_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent)) {
              _provider.loadMoreOrders();
            }
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        _provider = ref.watch(driverHomepageProvider);

        return RefreshIndicator(
          onRefresh: _provider.refreshPage,
          child: ScrollableColumn(
            mainAxisSize: MainAxisSize.min,
            controller: _scrollController,
            padding: EdgeInsets.zero,
            physics: _provider.loading
                ? const NeverScrollableScrollPhysics()
                : const AlwaysScrollableScrollPhysics(),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Ready For Delivery',
                    style: TextStyle(
                      fontFamily: AppFontFamily.abrilFatface,
                      fontWeight: FontWeight.w600,
                      fontSize: Sizes.s18.sp,
                    ),
                  ),
                ],
              ),
              SizedBoxH10(),
              _provider.loading
                  ? Loader.circularProgressIndicator()
                  : _provider.orders.isEmpty
                  ? const Center(child: NoDataAvailable())
                  : Flexible(
                fit: FlexFit.loose,
                child: ListView.builder(
                  itemCount: _provider.orders.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    final curOrder = _provider.orders[index];

                    return DriverHomepageCard(
                      orders: curOrder,
                      onToggle: _provider.onToggle,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
