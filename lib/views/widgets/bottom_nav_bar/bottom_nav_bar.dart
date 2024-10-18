import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/utils/enums.dart';
import 'package:alcoholdeliver/views/screens/home/main_home.dart';
import 'package:alcoholdeliver/views/widgets/bottom_nav_bar/navigation_item.dart';
import 'package:flutter/material.dart';

class PrimaryBottomNavBar extends StatelessWidget {
  final NavigationTab currentTab;
  const PrimaryBottomNavBar({super.key, required this.currentTab});

  @override
  Widget build(BuildContext context) {
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
                    labelColor: AppColors.primaryFontColor,
                    iconColor: AppColors.secondaryFontColor,
                    assetName: currentTab == NavigationTab.home ? AppAssets.icHome : AppAssets.icHomeFilled,
                    isSelected: currentTab == NavigationTab.home,
                    selectedIconColor: AppColors.whiteFontColor,
                    selectedLabelColor: AppColors.whiteFontColor,
                    onTap: () => bottomTabNotifier.value = NavigationTab.home,
                  ),
                  NavigationItem(
                    label: 'My Orders',
                    labelColor: AppColors.primaryFontColor,
                    iconColor: AppColors.secondaryFontColor,
                    selectedIconColor: AppColors.whiteFontColor,
                    selectedLabelColor: AppColors.whiteFontColor,
                    assetName: currentTab == NavigationTab.myOrders ? AppAssets.icMyOrders : AppAssets.icMyOrdersFilled,
                    isSelected: currentTab == NavigationTab.myOrders,
                    onTap: () => bottomTabNotifier.value = NavigationTab.myOrders,
                  ),
                  NavigationItem(
                    label: 'Account',
                    labelColor: AppColors.primaryFontColor,
                    iconColor: AppColors.secondaryFontColor,
                    selectedIconColor: AppColors.whiteFontColor,
                    selectedLabelColor: AppColors.whiteFontColor,
                    isSelected: currentTab == NavigationTab.accounts,
                    assetName: currentTab == NavigationTab.accounts ? AppAssets.icAccount : AppAssets.icAccountsFilled,
                    onTap: () => bottomTabNotifier.value = NavigationTab.accounts,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
