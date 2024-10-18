import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrimaryTimeSelector extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final Function setSelectedTime;
  final String label;
  final bool showError;
  final bool show24HoursFormat;
  final String? icon;
  final TimeOfDay? minTime;
  final TimeOfDay? maxTime;

  const PrimaryTimeSelector({
    super.key,
    required this.selectedTime,
    required this.setSelectedTime,
    required this.label,
    this.showError = false,
    this.show24HoursFormat = true,
    this.icon,
    this.minTime,
    this.maxTime,
  });

  Widget _getShowText() {
    final String showTime = selectedTime != null
        ? show24HoursFormat
            ? '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'
            : '${selectedTime!.hourOfPeriod.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')} ${selectedTime!.hour < 12 ? 'AM' : 'PM'}'
        : show24HoursFormat
            ? '00:00'
            : '00:00 AM';

    return Text(
      showTime,
      style: TextStyle(
        fontSize: Sizes.s16.sp,
        letterSpacing: 2,
        color: showTime == (show24HoursFormat ? '00:00' : '00:00 AM')
            ? AppColors.secondaryFontColor
            : AppColors.primaryFontColor,
        wordSpacing: 2,
      ),
    );
  }

  Future<void> onTimeChange(BuildContext context) async {
    TimeOfDay? newSelectedTime;
    bool validTime = false;

    while (!validTime) {
      newSelectedTime = await showTimePicker(
        initialTime: selectedTime ?? TimeOfDay.now(),
        context: context,
      );

      if (newSelectedTime == null) return;
      if (minTime == null || maxTime == null) continue;

      final newSelectedDateTime = DateTime(2024, 1, 1, newSelectedTime.hour, newSelectedTime.minute);
      final minDateTime = DateTime(2024, 1, 1, minTime!.hour, minTime!.minute);
      final maxDateTime = DateTime(2024, 1, 1, maxTime!.hour, maxTime!.minute);

      if (newSelectedDateTime.isAfter(minDateTime) && newSelectedDateTime.isBefore(maxDateTime)) {
        validTime = true;
      } else {
        validTime = false;
        // ignore: use_build_context_synchronously
        context.showFailureSnackBar('Please select a time within 10:30 AM to 8:30 PM.');
      }
    }

    if (newSelectedTime != null) {
      setSelectedTime(newSelectedTime);
    }

    // final newSelectedTime = await showTimePicker(
    //   initialTime: TimeOfDay.now(),
    //   context: context,
    // );

    // if (newSelectedTime != null) {
    //   setSelectedTime(newSelectedTime);
    // }
  }

  BoxBorder setBorder() {
    Color borderColor = showError ? Colors.red : AppColors.borderColor;
    return Border.all(
      width: 1,
      color: borderColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTimeChange(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.secondaryFontColor,
              fontSize: Sizes.s16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBoxH10(),
          Container(
            padding: EdgeInsets.all(Sizes.s14.sp),
            width: double.infinity,
            decoration: BoxDecoration(
              border: setBorder(),
              borderRadius: BorderRadius.circular(Sizes.s10.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _getShowText(),
                if (icon != null)
                  SvgPicture.asset(
                    icon!,
                    height: Sizes.s18.h,
                    width: Sizes.s18.h,
                  ),
              ],
            ),
          ),
          if (showError) ...[
            SizedBoxH5(),
            Text(
              '$label is Mandatory',
              style: const TextStyle(
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
