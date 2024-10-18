import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/utils/screen_util.dart';

class CIconButton extends StatelessWidget {
  final String icon;

  const CIconButton({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Sizes.s8),
      height: Sizes.s34.h,
      width: Sizes.s34.w,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        border: Border.all(
          width: 1,
          color: AppColors.primaryBorderColor,
        ),
        borderRadius: BorderRadius.circular(Sizes.s8.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: SvgPicture.asset(
          icon,
          height: Sizes.s24,
          width: Sizes.s24,
          colorFilter: const ColorFilter.mode(
            AppColors.whiteFontColor,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

class BlueDivider extends StatelessWidget {
  const BlueDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(thickness: 1, color: AppColors.borderColor);
  }
}

class EmptyText extends Text {
  EmptyText(super.text, {super.key, Color color = Colors.white, double? fontSize})
      : super(
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontSize: fontSize ?? Sizes.s18.sp,
            fontWeight: FontWeight.w600,
          ),
        );
}

class MandatorySign extends StatelessWidget {
  const MandatorySign({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '*',
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: AppColors.errorColor,
        fontSize: Sizes.s16.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class GreyDivider extends StatelessWidget {
  const GreyDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 1,
      color: AppColors.secondaryFontColor.withOpacity(0.4),
    );
  }
}

class BuildDivider extends StatelessWidget {
  const BuildDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: AppColors.darkBorderColor,
      thickness: 1,
    );
  }
}

class LeftAlignHeader extends StatelessWidget {
  final String header;

  const LeftAlignHeader({super.key, required this.header});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          header,
          style: TextStyle(
            color: AppColors.primaryFontColor,
            fontWeight: FontWeight.w600,
            fontSize: Sizes.s18.sp,
          ),
        ),
      ],
    );
  }
}

class ColumnText extends StatelessWidget {
  final String label;
  final String value;

  const ColumnText({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoldHeader(label),
        Text(
          value,
          style: TextStyle(
            color: AppColors.primaryFontColor,
            fontWeight: FontWeight.w400,
            fontSize: Sizes.s16.sp,
          ),
        ),
      ],
    );
  }
}

class BoldHeader extends StatelessWidget {
  final String label;

  const BoldHeader(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: AppColors.primaryFontColor,
        fontWeight: FontWeight.w600,
        fontSize: Sizes.s16.sp,
      ),
    );
  }
}

class NoDataAvailable extends StatelessWidget {
  final double? height;
  final String label;

  const NoDataAvailable({
    super.key,
    this.height,
    this.label = 'No Data Available',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? ScreenUtil().screenHeight * 0.8,
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: Sizes.s20.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class NoImageFound extends StatelessWidget {
  final double? height;
  final double? width;
  final double? radius;

  const NoImageFound({
    super.key,
    this.height,
    this.width,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(radius ?? 0),
      ),
      child: Center(
        child: Text(
          'No Image Found',
          style: TextStyle(
            fontSize: Sizes.s18.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class NoDataFound extends StatelessWidget {
  const NoDataFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No Data Found',
        style: TextStyle(
          color: AppColors.primaryFontColor,
          fontSize: Sizes.s20.sp,
        ),
      ),
    );
  }
}

class CommonStyle {
  CommonStyle._();

  static TextStyle commonParaStyle = TextStyle(
    letterSpacing: .5,
    fontSize: Sizes.s16.h,
  );

  static TextStyle commonHeaderStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: Sizes.s18.h,
  );
}
