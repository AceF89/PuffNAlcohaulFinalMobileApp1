import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  final Widget child;
  final Color bgColor;
  final double radius;
  final double? width;
  final double? height;
  final EdgeInsets margin;
  final Color borderColor;
  final EdgeInsets padding;
  final double borderWidth;
  final VoidCallback? onTap;

  const RoundedContainer({
    super.key,
    this.width,
    this.onTap,
    this.height,
    required this.child,
    this.borderWidth = 0,
    this.radius = Sizes.s10,
    this.margin = EdgeInsets.zero,
    this.borderColor = Colors.transparent,
    this.bgColor = AppColors.backgroundColor,
    this.padding = const EdgeInsets.all(Sizes.s10),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        margin: margin,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(
            width: borderWidth,
            color: borderColor,
          ),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: child,
      ),
    );
  }
}
