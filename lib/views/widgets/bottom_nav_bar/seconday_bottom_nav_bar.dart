import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/utils/enums.dart';
import 'package:alcoholdeliver/views/screens/home/main_home.dart';
import 'package:alcoholdeliver/views/widgets/bottom_nav_bar/navigation_item.dart';
import 'package:flutter/material.dart';

late ValueNotifier<NavigationTab> secondaryBottomTabNotifier;

class SecondaryBottomNavBar extends StatefulWidget {
  const SecondaryBottomNavBar({super.key});

  @override
  State<SecondaryBottomNavBar> createState() => _SecondaryBottomNavBarState();
}

class _SecondaryBottomNavBarState extends State<SecondaryBottomNavBar> {
  @override
  void initState() {
    super.initState();
    secondaryBottomTabNotifier = ValueNotifier(NavigationTab.home);
  }

  void onChangeTab(NavigationTab newTab) {
    secondaryBottomTabNotifier.value = newTab;
    bottomTabNotifier.value = newTab;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<NavigationTab>(
      valueListenable: secondaryBottomTabNotifier,
      builder: (context, currentTab, _) {
        return Material(
          color: Colors.transparent,
          child: SafeArea(
            child: Container(
              width: Sizes.s300,
              padding: const EdgeInsets.all(Sizes.s8),
              margin: const EdgeInsets.symmetric(
                horizontal: Sizes.s26,
                vertical: Sizes.s10,
              ),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(Sizes.s100.sp),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.14),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      NavigationItem(
                        label: 'Home',
                        isSelected: false,
                        labelColor: AppColors.primaryFontColor,
                        iconColor: AppColors.secondaryFontColor,
                        assetName: currentTab == NavigationTab.home ? AppAssets.icHome : AppAssets.icHomeFilled,
                        selectedIconColor: AppColors.whiteFontColor,
                        selectedLabelColor: AppColors.whiteFontColor,
                        onTap: () => onChangeTab(NavigationTab.home),
                      ),
                      NavigationItem(
                        isSelected: false,
                        label: 'My Orders',
                        labelColor: AppColors.primaryFontColor,
                        iconColor: AppColors.secondaryFontColor,
                        selectedIconColor: AppColors.whiteFontColor,
                        selectedLabelColor: AppColors.whiteFontColor,
                        assetName:
                            currentTab == NavigationTab.myOrders ? AppAssets.icMyOrders : AppAssets.icMyOrdersFilled,
                        onTap: () => onChangeTab(NavigationTab.myOrders),
                      ),
                      NavigationItem(
                        label: 'Account',
                        isSelected: false,
                        labelColor: AppColors.primaryFontColor,
                        iconColor: AppColors.secondaryFontColor,
                        selectedIconColor: AppColors.whiteFontColor,
                        selectedLabelColor: AppColors.whiteFontColor,
                        assetName:
                            currentTab == NavigationTab.accounts ? AppAssets.icAccount : AppAssets.icAccountsFilled,
                        onTap: () => onChangeTab(NavigationTab.accounts),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
