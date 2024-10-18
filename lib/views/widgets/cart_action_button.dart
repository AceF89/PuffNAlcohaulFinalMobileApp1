import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/providers/cart_provider.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:alcoholdeliver/views/screens/homepage/widgets/icon_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartActionButton extends StatefulWidget {
  const CartActionButton({super.key});

  @override
  State<CartActionButton> createState() => _CartActionButtonState();
}

class _CartActionButtonState extends State<CartActionButton> {
  late CartProvider provider;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      provider = ref.watch(cartProvider);

      return IconContainer(
        icon: AppAssets.icCart2,
        iconHeight: Sizes.s30,
        iconWidth: Sizes.s30,
        colorFilter: const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
        badgeValue: provider.cartCount == 0
            ? null
            : Positioned(
                right: 0,
                child: Container(
                  height: Sizes.s20,
                  width: Sizes.s20,
                  padding: const EdgeInsets.all(Sizes.s2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(Sizes.s200),
                  ),
                  child: Center(
                    child: Text(
                      provider.cartCount > 9 ? '9+' : provider.cartCount.toString(),
                      style: TextStyle(
                        fontSize: Sizes.s12.sp,
                      ),
                    ),
                  ),
                ),
              ),
        onTap: () {
          Navigator.of(context).pushNamed(Routes.checkout);
        },
      );
    });
  }
}
