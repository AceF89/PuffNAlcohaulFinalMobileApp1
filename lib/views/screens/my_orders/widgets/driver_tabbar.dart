import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class DriverTabbar extends StatelessWidget {
  final Map<int, String> tabList;
  final int selectedIndex;
  final Function onPressed;

  final List<int> keys = [];
  final List<String> values = [];

  DriverTabbar({
    super.key,
    required this.tabList,
    required this.selectedIndex,
    required this.onPressed,
  }) {
    keys.addAll(tabList.keys.toList());
    values.addAll(tabList.values.toList());
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tabList.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (ctx, i) {
        return _buildTab(values[i], keys[i], selectedIndex, context);
      },
    );
  }

  Widget _buildTab(String text, int id, int selectedIndex, BuildContext context) {
    final isSelected = selectedIndex == id;
    return GestureDetector(
      onTap: () {
        onPressed(id, context);
      },
      child: Container(
        margin: EdgeInsets.only(right: Sizes.s10.h),
        padding: const EdgeInsets.symmetric(horizontal: Sizes.s20),
        constraints: BoxConstraints(
          minWidth: Sizes.s80.h,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.darkBorderColor : Colors.transparent,
          borderRadius: BorderRadius.circular(Sizes.s20.h),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? AppColors.primaryFontColor : AppColors.iconColor,
              fontWeight: FontWeight.w400,
              fontSize: Sizes.s18.h,
            ),
          ),
        ),
      ),
    );
  }
}
