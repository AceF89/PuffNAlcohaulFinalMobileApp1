import 'package:alcoholdeliver/views/widgets/common_widgets.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';

class InputFormatters {
  static FilteringTextInputFormatter alphabetWithSpace = FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]'));
}

class PrimaryTextField extends FormField<String> {
  final String hintText;
  final bool readOnly;
  final int maxLines;
  final double bWidth;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color backgroundColor;
  final bool showBorder;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onTap;
  final TextInputAction? textInputAction;
  final double? height;
  final String? labelText;
  final bool? isMandatory;
  final Color? bColor;
  final Color? labelColor;
  final Color? hintColor;
  final FocusNode? focusNode;
  final BoxConstraints? prefixIconConstraints;
  final void Function()? onEditingComplete;

  PrimaryTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.textInputAction,
    this.suffixIcon = const SizedBox(),
    this.inputFormatters,
    this.backgroundColor = Colors.transparent,
    this.maxLines = 1,
    this.bWidth = 1,
    this.readOnly = false,
    this.showBorder = true,
    this.onTap,
    this.prefixIconConstraints,
    AutovalidateMode super.autovalidateMode = AutovalidateMode.onUserInteraction,
    super.validator,
    ValueChanged<String>? onChanged,
    this.height,
    this.labelText,
    this.isMandatory = false,
    this.bColor,
    this.labelColor = AppColors.primaryFontColor,
    this.hintColor,
    this.focusNode,
    this.onEditingComplete,
  }) : super(
          initialValue: controller.text,
          builder: (FormFieldState<String> field) {
            void onChangedHandler(String value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            BoxBorder setBorder() {
              Color borderColor = (!field.isValid && field.errorText == null)
                  ? bColor ?? AppColors.borderColor
                  : field.isValid
                      ? bColor ?? AppColors.borderColor
                      : Colors.red;
              return Border.all(
                width: bWidth,
                color: borderColor,
              );
            }

            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (labelText != null) ...[
                    Row(
                      children: [
                        Text(
                          labelText,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: labelColor,
                            fontSize: Sizes.s16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (isMandatory == true) const MandatorySign()
                      ],
                    ),
                    SizedBoxH5(),
                  ],
                  Container(
                    height: height,
                    padding: prefixIcon == null ? EdgeInsets.only(left: Sizes.s12.h) : EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(Sizes.s10.r),
                      border: showBorder ? setBorder() : null,
                    ),
                    child: TextField(
                      focusNode: focusNode,
                      cursorColor: AppColors.primaryColor,
                      autocorrect: false,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Sizes.s16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      textInputAction: textInputAction,
                      textAlignVertical: TextAlignVertical.center,
                      maxLines: maxLines,
                      onTap: onTap,
                      controller: controller,
                      keyboardType: keyboardType,
                      onChanged: onChangedHandler,
                      readOnly: readOnly,
                      obscureText: obscureText,
                      inputFormatters: inputFormatters,
                      onEditingComplete: onEditingComplete,
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: TextStyle(
                          color: hintColor,
                        ),
                        prefixIconConstraints: prefixIconConstraints,
                        prefixIcon: prefixIcon,
                        suffixIcon: suffixIcon,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (!field.isValid && field.errorText != null)
                    Visibility(
                      visible: !field.isValid,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 7, left: 3),
                        child: Text(
                          field.errorText ?? '',
                          style: TextStyle(
                            fontSize: Sizes.s12.sp,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
}
