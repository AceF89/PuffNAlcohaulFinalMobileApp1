import 'package:flutter/material.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';

class CheckBox extends StatelessWidget {
  final bool isChecked;
  final String? label;
  final Widget? customLabel;
  final Function(bool?) onChanged;

  const CheckBox({
    super.key,
    this.customLabel,
    required this.isChecked,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Theme(
          data: ThemeData(
            unselectedWidgetColor: AppColors.primaryColor,
          ),
          child: Checkbox(
            value: isChecked,
            onChanged: onChanged,
            activeColor: Colors.transparent,
            checkColor: Colors.white,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            fillColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primaryColor;
                }
                return Colors.transparent;
              },
            ),
            side: WidgetStateBorderSide.resolveWith(
              (states) {
                return const BorderSide(width: 1.0, color: AppColors.primaryColor);
              },
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizes.s4),
              side: const BorderSide(
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ),
        if (label != null)
          Text(
            label!,
            style: TextStyle(
              color: AppColors.primaryFontColor,
              fontWeight: FontWeight.w500,
              fontSize: Sizes.s14.h,
            ),
          ),
      ],
    );
  }
}
