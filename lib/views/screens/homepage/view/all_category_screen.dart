import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/model/product_categories.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:alcoholdeliver/views/screens/homepage/provider/all_category_provider.dart';
import 'package:alcoholdeliver/views/screens/homepage/widgets/category_card.dart';
import 'package:alcoholdeliver/views/widgets/app_bar/back_app_bar.dart';
import 'package:alcoholdeliver/views/widgets/bottom_nav_bar/seconday_bottom_nav_bar.dart';
import 'package:alcoholdeliver/views/widgets/cart_action_button.dart';
import 'package:alcoholdeliver/views/widgets/primary_text_field.dart';
import 'package:alcoholdeliver/views/widgets/scrollable_column.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllCategoryScreen extends StatefulWidget {
  final List<ProductCategories> catgories;

  const AllCategoryScreen({super.key, required this.catgories});

  @override
  State<AllCategoryScreen> createState() => _AllCategoryScreenState();
}

class _AllCategoryScreenState extends State<AllCategoryScreen> {
  late AllCategoryProvider _provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.setupCategoris(widget.catgories);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context,
        title: 'Categories',
        actions: [
          const CartActionButton(),
          SizedBoxW20(),
        ],
      ),
      body: Consumer(builder: (context, ref, _) {
        _provider = ref.watch(allCategoryProvider);

        return ScrollableColumn.withSafeArea(
          children: [
            PrimaryTextField(
              hintText: 'Search Categories',
              controller: _provider.searchController,
              onChanged: _provider.onChangeSearch,
            ),
            SizedBoxH20(),
            GridView.builder(
              itemCount: _provider.searchedCatgories.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                crossAxisSpacing: Sizes.s20,
                mainAxisSpacing: Sizes.s20,
                mainAxisExtent: 60,
              ),
              itemBuilder: (context, index) {
                final curCategory = _provider.searchedCatgories[index];

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
            SizedBoxH20(),
          ],
        );
      }),
      bottomNavigationBar: const SecondaryBottomNavBar(),
    );
  }
}
