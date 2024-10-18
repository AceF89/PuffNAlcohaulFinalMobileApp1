import 'package:flutter/material.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_font_family.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/utils/screen_util.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final double? fontSize;
  final double? height;
  final double? width;
  final Color color;
  final double? borderRadius;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry padding;
  final bool outlined;
  final Color? textColor;
  final Color? outlinedColor;
  final bool showShadow;
  final Widget? child;
  final FontWeight? labelWeight;

  const PrimaryButton({
    super.key,
    this.label = '',
    this.width,
    this.fontSize,
    this.height,
    this.borderRadius,
    this.color = AppColors.primaryColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
    required this.onPressed,
    this.child,
    this.textColor,
    this.outlinedColor,
    this.showShadow = false,
    this.labelWeight = FontWeight.w600,
    this.outlined = false,
  });

  const PrimaryButton.outlined({
    super.key,
    required this.label,
    this.width,
    this.fontSize,
    this.height,
    this.borderRadius,
    this.color = AppColors.whiteFontColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
    required this.onPressed,
    this.child,
    this.textColor = AppColors.primaryColor,
    this.outlinedColor = AppColors.primaryColor,
    this.showShadow = false,
    this.labelWeight = FontWeight.w600,
  }) : outlined = true;

  const PrimaryButton.disabled({
    super.key,
    required this.label,
    this.width,
    this.fontSize,
    this.height,
    this.borderRadius,
    this.color = AppColors.secondaryFontColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
    required this.onPressed,
    this.child,
    this.textColor = AppColors.secondaryFontColor,
    this.outlinedColor,
    this.showShadow = false,
    this.labelWeight = FontWeight.w600,
  }) : outlined = false;

  @override
  Widget build(BuildContext context) {
    var txtColor = outlined ? (textColor ?? color) : textColor ?? Colors.white;
    var backgroundColor = outlined ? Colors.transparent : color;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          borderRadius ?? BorderRadiusValues.extraRadiusSmall.r,
        ),
        boxShadow: [
          if (showShadow)
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: MaterialButton(
        textColor: txtColor,
        color: backgroundColor,
        elevation: 0,
        padding: padding,
        height: height ?? Sizes.s45.h,
        minWidth: width ?? ScreenUtil().screenWidth,
        highlightElevation: 0,
        disabledElevation: 0,
        disabledTextColor: txtColor.withOpacity(0.5),
        disabledColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? BorderRadiusValues.extraRadiusSmall.r,
          ),
          side: outlined
              ? BorderSide(
                  color: outlinedColor ?? color,
                  width: Sizes.s1.h,
                )
              : BorderSide.none,
        ),
        onPressed: onPressed != null
            ? () {
                FocusScope.of(context).requestFocus(FocusNode());
                onPressed?.call();
              }
            : null,
        child: child ??
            FittedBox(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize?.sp ?? Sizes.s16.sp,
                  fontWeight: labelWeight,
                ),
              ),
            ),
      ),
    );
  }
}

class PrimaryTextButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final double? fontSize;
  final Widget? prefixIcon;
  final Widget? postfixIcon;
  final VoidCallback? onPressed;
  final FontWeight? fontWeight;
  final EdgeInsets? padding;
  final bool showUnderline;

  const PrimaryTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.fontSize,
    this.fontWeight,
    this.color = AppColors.primaryColor,
    this.textColor = AppColors.primaryColor,
    this.prefixIcon,
    this.postfixIcon,
    this.padding,
    this.showUnderline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (prefixIcon != null) ...[
          prefixIcon!,
          SizedBoxW10(),
        ],
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: color,
            elevation: 0,
            textStyle: TextStyle(
              fontFamily: AppFontFamily.poppins,
              fontSize: fontSize?.sp ?? Sizes.s16.sp,
              fontWeight: fontWeight ?? FontWeight.w600,
            ),
            padding: padding ?? EdgeInsets.symmetric(horizontal: Sizes.s4.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizes.s6.r),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              decoration: showUnderline
                  ? TextDecoration.underline
                  : TextDecoration.none,
            ),
          ),
        ),
        if (postfixIcon != null) ...[
          SizedBoxW10(),
          postfixIcon!,
        ],
      ],
    );
  }
}
