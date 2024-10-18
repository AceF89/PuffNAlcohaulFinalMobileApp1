import 'package:alcoholdeliver/views/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter_svg/svg.dart';

class PrimaryDateSelector extends StatefulWidget {
  final DateTime? selectedDate;
  final Function setSelectedDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String label;
  final bool showError;
  final String? icon;
  final bool isMandatory;
  final String dateFormate;
  final List<int> disabledDays;

  const PrimaryDateSelector({
    super.key,
    required this.selectedDate,
    required this.setSelectedDate,
    this.firstDate,
    this.lastDate,
    required this.label,
    this.showError = false,
    this.icon,
    this.isMandatory = false,
    this.dateFormate = 'DD / MM / YY',
    this.disabledDays = const [],
  });

  @override
  State<PrimaryDateSelector> createState() => _PrimaryDateSelectorState();
}

class _PrimaryDateSelectorState extends State<PrimaryDateSelector> {
  String get _placeHolder => widget.dateFormate == 'DD / MM / YY' ? 'DD / MM / YY' : 'MM / DD / YY';

  String get _formatedDate {
    if (widget.dateFormate == 'DD / MM / YY') {
      return '${widget.selectedDate?.day} / ${widget.selectedDate?.month} / ${widget.selectedDate?.year}';
    } else {
      return '${widget.selectedDate?.month} / ${widget.selectedDate?.day} / ${widget.selectedDate?.year}';
    }
  }

  Widget _getShowText() {
    if (widget.selectedDate == null) {
      return Text(
        _placeHolder,
        style: TextStyle(
          color: AppColors.secondaryFontColor.withOpacity(0.5),
        ),
      );
    } else {
      /// Return Generated Date & Time
      return Text(
        _formatedDate,
        style: const TextStyle(
          letterSpacing: 2,
          wordSpacing: 2,
          color: AppColors.primaryFontColor,
        ),
      );
    }
  }

  BoxBorder setBorder() {
    Color borderColor = widget.showError ? Colors.red : AppColors.borderColor;
    return Border.all(
      width: 1,
      color: borderColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        /// Show Date Picker
        final DateTime? newSelectedDate = await showDatePicker(
          context: context,
          initialDate: widget.selectedDate ?? DateTime.now(),
          firstDate: widget.firstDate == null ? DateTime(DateTime.now().year - 50) : widget.firstDate!,
          lastDate: widget.lastDate == null ? DateTime(DateTime.now().year + 50) : widget.lastDate!,
          selectableDayPredicate: (DateTime date) {
            return !widget.disabledDays.contains(date.weekday);
          },
        );

        /// Check Guard: If Date is Null Return
        if (newSelectedDate == null) return;

        /// If User select Date or Time Change State
        widget.setSelectedDate(n: newSelectedDate);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.secondaryFontColor,
                  fontSize: Sizes.s16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (widget.isMandatory == true) const MandatorySign()
            ],
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
                if (widget.icon != null)
                  SvgPicture.asset(
                    widget.icon!,
                    height: Sizes.s18.h,
                    width: Sizes.s18.h,
                  ),
              ],
            ),
          ),
          if (widget.showError) ...[
            SizedBoxH5(),
            Text(
              '${widget.label} is Mandatory',
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
