import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/model/menu_items.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';

class RadioBox extends StatelessWidget {
  final String? label;
  final List<MenuItems> items;
  final String selectedValue;
  final Function(String) onChange;

  const RadioBox({
    super.key,
    required this.items,
    this.label,
    required this.selectedValue,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              color: AppColors.secondaryFontColor,
              fontSize: Sizes.s16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBoxH10(),
        ],
        Wrap(
          children: items.map((item) {
            return InkWell(
              onTap: () => onChange(item.selectedValue),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: item.selectedValue,
                    groupValue: selectedValue,
                    onChanged: (value) => onChange(value.toString()),
                  ),
                  SizedBoxW05(),
                  Text(item.label),
                  SizedBoxW20(),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
