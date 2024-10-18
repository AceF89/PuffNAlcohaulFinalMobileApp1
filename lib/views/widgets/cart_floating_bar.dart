import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/utils/screen_util.dart';
import 'package:alcoholdeliver/providers/cart_provider.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CartFloatingBar extends StatelessWidget {
  final double marginBottom;

  const CartFloatingBar({
    super.key,
    this.marginBottom = Sizes.s8,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final provider = ref.watch(cartProvider);

        return provider.showCartBar
            ? Container(
                width: ScreenUtil().screenWidth,
                height: Sizes.s44.h,
                padding: EdgeInsets.all(Sizes.s12.sp),
                margin: EdgeInsets.symmetric(
                  horizontal: Sizes.s16.sp,
                  vertical: marginBottom,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(Sizes.s10.sp),
                ),
                child: Row(
                  children: [
                    Text(
                      '${provider.cartCount} Item Added',
                      style: TextStyle(
                        color: AppColors.whiteFontColor,
                        fontWeight: FontWeight.w500,
                        fontSize: Sizes.s14.sp,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.checkout);
                      },
                      child: Text(
                        'View Cart',
                        style: TextStyle(
                          color: AppColors.whiteFontColor,
                          fontWeight: FontWeight.w500,
                          fontSize: Sizes.s14.sp,
                        ),
                      ),
                    ),
                    SizedBoxW10(),
                    SvgPicture.asset(
                      AppAssets.icForwardArrow,
                      height: Sizes.s14,
                      width: Sizes.s14,
                      colorFilter: const ColorFilter.mode(
                        AppColors.whiteFontColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox();
      },
    );
  }
}
