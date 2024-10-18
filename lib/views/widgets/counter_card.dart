import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/views/screens/homepage/widgets/icon_containers.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';

class CounterCard extends StatefulWidget {
  final num? maxValue;
  final int initialCounter;
  final int maxLessValue;
  final ValueChanged<int> onChange;
  final ValueChanged<int>? onIncrement;
  final ValueChanged<int>? onDecrement;
  final int? currentCounter;
  final bool disableButtonsOnMaxValue;
  final String? maxValueErrorMessage;

  const CounterCard({
    super.key,
    this.maxLessValue = 0,
    required this.initialCounter,
    required this.onChange,
    this.onIncrement,
    this.onDecrement,
    this.currentCounter,
    this.maxValue,
    this.maxValueErrorMessage,
    this.disableButtonsOnMaxValue = false,
  });

  @override
  State<CounterCard> createState() => _CounterCardState();
}

class _CounterCardState extends State<CounterCard> {
  late int _counter;

  @override
  void initState() {
    super.initState();
    _counter = widget.initialCounter;
  }

  @override
  void didUpdateWidget(covariant CounterCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentCounter != null && widget.currentCounter != _counter) {
      _counter = widget.currentCounter!;
    }
  }

  void _incrementCounter() {
    if (widget.maxValue != null && _counter >= widget.maxValue!) {
      if (widget.maxValueErrorMessage != null) {
        context.showFailureSnackBar(widget.maxValueErrorMessage!);
      }
      return;
    }

    setState(() {
      _counter++;
      widget.onChange(_counter);
      widget.onIncrement?.call(_counter);
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > widget.maxLessValue) {
        _counter--;
        widget.onChange(_counter);
        widget.onDecrement?.call(_counter);
      }
    });
  }

  Color get _buttonColor {
    Color color = AppColors.primaryColor;

    if (widget.disableButtonsOnMaxValue) {
      if (_counter >= (widget.maxValue ?? 0)) {
        color = AppColors.iconColor;
      } else {
        color = AppColors.primaryColor;
      }
    }

    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Sizes.s2.sp,
        horizontal: Sizes.s6.sp,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _decrementCounter,
            child: IconContainer(
              height: Sizes.s30.h,
              width: Sizes.s30.w,
              radius: Sizes.s6.sp,
              icon: AppAssets.icSubtract,
            ),
          ),
          SizedBoxW10(),
          Text(
            '$_counter',
            style: TextStyle(
              fontSize: Sizes.s16.sp,
            ),
          ),
          SizedBoxW10(),
          GestureDetector(
            onTap: _incrementCounter,
            child: IconContainer(
              icon: AppAssets.icAdd,
              height: Sizes.s30.h,
              width: Sizes.s30.w,
              radius: Sizes.s6.sp,
              fillColor: _buttonColor,
            ),
          ),
        ],
      ),
    );
  }
}
