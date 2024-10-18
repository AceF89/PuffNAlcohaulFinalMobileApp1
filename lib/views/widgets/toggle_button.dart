import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';

class ToggleButton extends StatefulWidget {
  final String label;
  final bool spaceBetween;
  final Function(bool)? onChanged;
  final bool? initialValue;

  const ToggleButton({
    super.key,
    required this.label,
    this.onChanged,
    this.spaceBetween = false,
    this.initialValue,
  });

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  late bool _isToggled;

  @override
  void initState() {
    super.initState();
    _isToggled = widget.initialValue ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isToggled = !_isToggled;
              widget.onChanged?.call(_isToggled);
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: Sizes.s40.w,
            height: Sizes.s20.h,
            decoration: BoxDecoration(
              color: _isToggled
                  ? AppColors.primaryColor
                  : AppColors.secondaryFontColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(Sizes.s15.sp),
            ),
            child: Stack(
              children: [
                AnimatedAlign(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment:
                      _isToggled ? Alignment.centerRight : Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Sizes.s2.sp,
                    ),
                    child: Container(
                      width: Sizes.s18.w,
                      height: Sizes.s18.h,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        widget.spaceBetween ? const Spacer() : SizedBoxW05(),
        Text(
          widget.label,
          style: const TextStyle(
            color: AppColors.primaryFontColor,
          ),
        ),
      ],
    );
  }
}
