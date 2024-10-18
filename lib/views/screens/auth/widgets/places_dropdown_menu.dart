import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/utils/screen_util.dart';
import 'package:alcoholdeliver/model/places.dart';
import 'package:alcoholdeliver/views/widgets/expanded_section.dart';
import 'package:alcoholdeliver/views/widgets/primary_text_field.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';

class PlacesDropdownMenu extends StatelessWidget {
  final String label;
  final String hintText;
  final bool isExpanded;
  final VoidCallback onToggleDropdown;
  final TextEditingController controller;
  final List<Places> places;
  final Function onSelectOption;
  final bool showError;
  final bool isMandatory;

  const PlacesDropdownMenu({
    super.key,
    required this.isExpanded,
    required this.onToggleDropdown,
    required this.controller,
    required this.places,
    required this.onSelectOption,
    required this.label,
    required this.hintText,
    this.showError = false,
    this.isMandatory = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryTextField(
          labelText: label,
          labelColor: AppColors.secondaryFontColor,
          hintText: hintText,
          validator: (value) => null,
          keyboardType: TextInputType.name,
          readOnly: true,
          suffixIcon: Icon(
            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: Colors.grey,
            size: Sizes.s26.h,
          ),
          isMandatory: isMandatory,
          onTap: onToggleDropdown,
          controller: controller,
        ),
        ExpandedSection(
          expand: isExpanded,
          child: Container(
            height: ScreenUtil().screenHeight * 0.2,
            width: double.infinity,
            padding: EdgeInsets.all(Sizes.s4.h),
            decoration: BoxDecoration(
              color: AppColors.lightBackgroundColor,
              borderRadius: BorderRadius.circular(Sizes.s4.h),
              border: Border.all(width: Sizes.s1.h, color: AppColors.borderColor),
            ),
            child: ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: places.length,
              itemBuilder: (_, i) {
                final currPlace = places[i];
                return InkWell(
                  onTap: () => onSelectOption(currPlace),
                  child: Container(
                    height: Sizes.s45.h,
                    width: ScreenUtil().screenWidth,
                    padding: EdgeInsets.symmetric(horizontal: Sizes.s6.h),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      currPlace.name.toString(),
                      style: TextStyle(
                        fontSize: Sizes.s15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) {
                return const Divider(
                  height: 0,
                  color: AppColors.darkBorderColor,
                );
              },
            ),
          ),
        ),
        if (showError) ...[
          SizedBoxH5(),
          Text(
            '$label is Mandatory',
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
        ],
      ],
    );
  }
}
