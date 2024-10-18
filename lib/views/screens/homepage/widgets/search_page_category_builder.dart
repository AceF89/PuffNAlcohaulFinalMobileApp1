import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/model/product_categories.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SearchPageCategoryBuilder extends StatelessWidget {
  final List<ProductCategories> categories;

  const SearchPageCategoryBuilder({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizes.s140.h,
      child: ListView.builder(
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final curCategory = categories[index];

          return ImageWithLabelWidget(
            imageUrl: curCategory.fullIconFileUrl ?? '',
            label: curCategory.name ?? 'N/A',
            onTap: () {
              Navigator.of(context).pushNamed(
                Routes.product,
                arguments: curCategory,
              );
            },
          );
        },
      ),
    );
  }
}

class ImageWithLabelWidget extends StatelessWidget {
  final String imageUrl;
  final String label;
  final VoidCallback onTap;

  const ImageWithLabelWidget({
    super.key,
    required this.imageUrl,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: Sizes.s20),
        height: Sizes.s140.h,
        width: Sizes.s140.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.s20.sp),
          color: AppColors.primaryBorderColor,
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.6),
              BlendMode.darken,
            ),
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.s10),
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.s8),
                  child: AutoSizeText(
                    label,
                    textAlign: TextAlign.center,
                    maxFontSize: Sizes.s24.sp,
                    minFontSize: Sizes.s18.sp,
                    maxLines: 2,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                //     ), Text(
                //   label,
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: Sizes.s24.sp,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
