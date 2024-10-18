import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/views/widgets/image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IconContainer extends StatelessWidget {
  final String icon;
  final Color fillColor;
  final Color borderColor;
  final double height;
  final double width;
  final double iconHeight;
  final double iconWidth;
  final double radius;
  final VoidCallback? onTap;
  final Widget? badgeValue;
  final ColorFilter? colorFilter;
  final double borderWidth;
  final EdgeInsets padding;

  const IconContainer({
    super.key,
    required this.icon,
    this.fillColor = Colors.transparent,
    this.borderColor = AppColors.borderColor,
    this.height = Sizes.s40,
    this.width = Sizes.s40,
    this.iconHeight = Sizes.s20,
    this.iconWidth = Sizes.s20,
    this.radius = Sizes.s10,
    this.onTap,
    this.badgeValue,
    this.colorFilter,
    this.borderWidth = 1,
    this.padding = const EdgeInsets.all(Sizes.s8),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: height,
            width: width,
            padding: padding,
            decoration: BoxDecoration(
              color: fillColor,
              border: Border.all(
                width: borderWidth,
                color: borderColor,
              ),
              borderRadius: BorderRadius.circular(radius),
            ),
            child: icon.endsWith('.svg')
                ? SvgPicture.asset(
                    icon,
                    height: iconHeight,
                    width: iconWidth,
                    colorFilter: colorFilter,
                  )
                : ImageView(
                    imageUrl: icon,
                    height: iconHeight,
                    width: iconWidth,
                    radius: BorderRadius.circular(radius),
                  ),
          ),
          if (badgeValue != null) badgeValue!
        ],
      ),
    );
  }
}
