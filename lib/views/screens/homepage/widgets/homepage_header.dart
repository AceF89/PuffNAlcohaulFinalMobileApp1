import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_font_family.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/utils/utils.dart';
import 'package:alcoholdeliver/providers/cart_provider.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:alcoholdeliver/views/screens/homepage/dialog/store_selection_dialog.dart';
import 'package:alcoholdeliver/views/screens/homepage/provider/homepage_provider.dart';
import 'package:alcoholdeliver/views/screens/homepage/widgets/icon_containers.dart';
import 'package:alcoholdeliver/views/widgets/cart_action_button.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class HomepageHeader extends StatefulWidget {
  const HomepageHeader({super.key});

  @override
  State<HomepageHeader> createState() => _HomepageHeaderState();
}

class _HomepageHeaderState extends State<HomepageHeader> {
  late CartProvider provider;
  late HomepageProvider homePageProvider;

  String get username {
    final name = preferences.getUserProfile()?.fullName ?? 'N/A';
    if (name.isEmpty) return 'N/A';
    return name;
  }

  String get address {
    final address = preferences.getUserProfile()?.googleAddress ?? 'N/A';
    final zipcode = preferences.getUserProfile()?.zipCode;
    if (address.isEmpty) return 'N/A';
    if (homePageProvider.defaultAddress != null &&
        homePageProvider.defaultAddress!.address2 != null) {
      return Utils.getDisplayAddress(
          homePageProvider.defaultAddress!.address,
          homePageProvider.defaultAddress!.googleAddress,
          homePageProvider.defaultAddress!.address2);
    }

    return '$address ${zipcode ?? ''} ';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      provider = ref.watch(cartProvider);
      homePageProvider = ref.watch(homepageProvider);

      return Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(Routes.myAddress)
                    .then((_) => provider.getMe(context));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi $username!',
                    style: TextStyle(
                      fontFamily: AppFontFamily.abrilFatface,
                      fontWeight: FontWeight.w600,
                      fontSize: Sizes.s18.sp,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        AppAssets.icMarkerBlue,
                        height: Sizes.s18,
                        width: Sizes.s18,
                      ),
                      SizedBoxW10(),
                      Expanded(
                        child: Text(
                          address,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: Sizes.s14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBoxW10(),
          IconContainer(
            icon: AppAssets.icBell,
            onTap: () => Navigator.of(context).pushNamed(Routes.notification),
          ),
          SizedBoxW10(),
          const CartActionButton(),
        ],
      );
    });
  }
}

class DriverHomepageHeader extends StatelessWidget {
  const DriverHomepageHeader({super.key});

  String get username {
    final name = preferences.getUserProfile()?.fullName ?? 'N/A';
    if (name.isEmpty) return 'N/A';
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Hi $username!',
          style: TextStyle(
            fontFamily: AppFontFamily.abrilFatface,
            fontWeight: FontWeight.w600,
            fontSize: Sizes.s18.sp,
          ),
        ),
        const Spacer(),
        IconContainer(
          icon: AppAssets.icFilter,
          onTap: () async {
            await StoreSelectionDialog.show(context);
          },
        ),
        SizedBoxW10(),
        IconContainer(
          icon: AppAssets.icBell,
          onTap: () => Navigator.of(context).pushNamed(Routes.notification),
        ),
      ],
    );
  }
}
