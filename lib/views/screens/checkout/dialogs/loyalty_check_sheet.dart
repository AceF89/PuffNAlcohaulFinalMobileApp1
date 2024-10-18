import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/views/widgets/primary_button.dart';
import 'package:alcoholdeliver/views/widgets/primary_text_field.dart';
import 'package:alcoholdeliver/views/widgets/scrollable_column.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';

class LoyaltyCheckSheet extends StatefulWidget {
  final TextEditingController controller;
  final Function onChange;

  const LoyaltyCheckSheet({
    super.key,
    required this.controller,
    required this.onChange,
  });

  static Future<bool> show(
    BuildContext context,
    TextEditingController controller,
    Function onChange,
  ) async {
    return await showModalBottomSheet<bool>(
          context: context,
          elevation: 0,
          barrierColor: Colors.black.withOpacity(0.2),
          enableDrag: false,
          isDismissible: false,
          clipBehavior: Clip.antiAlias,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Sizes.s8.r),
              topRight: Radius.circular(Sizes.s8.r),
            ),
          ),
          builder: (context) {
            return LoyaltyCheckSheet(
                controller: controller, onChange: onChange);
          },
        ) ??
        false;
  }

  @override
  State<LoyaltyCheckSheet> createState() => _LoyaltyCheckSheetState();
}

class _LoyaltyCheckSheetState extends State<LoyaltyCheckSheet> {
  num total = 0;
  final FocusNode _pointFocusNode = FocusNode();
  bool _isKeyboardOpen = false;
  String oldValue = '';

  @override
  void initState() {
    super.initState();
    oldValue = widget.controller.text;
    _pointFocusNode.addListener(() {
      setState(() => _isKeyboardOpen = _pointFocusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _pointFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollableColumn.withSafeArea(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBoxH20(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Loyalty Points',
              style: TextStyle(
                color: AppColors.primaryFontColor,
                fontSize: Sizes.s20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                if (oldValue.isNotEmpty) {
                  widget.onChange(num.parse(oldValue));
                  widget.controller.text = oldValue;
                }
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        SizedBoxH20(),
        Row(
          children: [
            _ColorBackgroundText(
              text:
                  preferences.getUserProfile()?.earnedloyaltyPoint.toString() ??
                      '0',
              subtext: 'Total Earned Points',
            ),
            SizedBoxW10(),
            _ColorBackgroundText(
              text: preferences
                      .getUserProfile()
                      ?.balanceloyaltyPoint
                      .toString() ??
                  '0',
              subtext: 'Total Purchase Points',
            ),
          ],
        ),
        if ((preferences.getUserProfile()?.balanceloyaltyPoint ?? 0) < 500) ...[
          SizedBoxH20(),
          const Text('You Should have atleast 500 Points to Redeem'),
          SizedBoxH20(),
        ],
        if ((preferences.getUserProfile()?.balanceloyaltyPoint ?? 0) > 500) ...[
          SizedBoxH20(),
          Row(
            children: [
              SizedBox(
                width: Sizes.s100,
                child: PrimaryTextField(
                  hintText: '',
                  focusNode: _pointFocusNode,
                  controller: widget.controller,
                  keyboardType: TextInputType.number,
                  onChanged: (String k) {
                    try {
                      final value = num.parse(k);
                      setState(() => total = value / 100);
                      widget.onChange(value);
                      // ignore: empty_catches
                    } catch (e) {}
                  },
                ),
              ),
              SizedBoxW40(),
              Text(
                '$total',
                style: const TextStyle(
                  fontSize: Sizes.s18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBoxH5(),
          const Text('Enter points wants to redeem'),
          SizedBoxH20(),
          PrimaryButton(
            label: 'Redeem',
            showShadow: true,
            onPressed: () {
              final avaiablePoints =
                  preferences.getUserProfile()?.balanceloyaltyPoint ?? 0;

              if (num.parse(widget.controller.text) > avaiablePoints) {
                context.showFailureSnackBar(
                    '${widget.controller.text} not available');
                return;
              }

              if (num.parse(widget.controller.text) < 500) {
                context.showFailureSnackBar(
                    'You can avail points greater than 500');
                return;
              }
              Navigator.of(context).pop();
            },
          ),
          SizedBoxH20(),
          if (_isKeyboardOpen) SizedBox(height: Sizes.s400.h),
        ],
      ],
    );
  }
}

class _ColorBackgroundText extends StatelessWidget {
  final String text;
  final String subtext;

  const _ColorBackgroundText({
    required this.text,
    required this.subtext,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: Sizes.s100.h,
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(Sizes.s10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: Sizes.s20.sp,
                color: AppColors.primaryFontColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBoxH5(),
            Text(
              subtext,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Sizes.s14.sp,
                color: AppColors.primaryFontColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
