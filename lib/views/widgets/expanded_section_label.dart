import 'package:flutter/material.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/views/widgets/expanded_section.dart';

class ExpandedSectionLabel extends StatefulWidget {
  final String label;
  final Widget child;
  final Color bgColor;
  final Color fontColor;

  const ExpandedSectionLabel({
    super.key,
    required this.label,
    required this.child,
    this.bgColor = Colors.white,
    this.fontColor = Colors.black,
  });

  @override
  State<ExpandedSectionLabel> createState() => _ExpandedSectionLabelState();
}

class _ExpandedSectionLabelState extends State<ExpandedSectionLabel> {
  bool showSection = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => showSection = !showSection),
          child: Container(
            width: double.infinity,
            color: widget.bgColor,
            padding: EdgeInsets.all(PaddingValues.paddingMedium.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      color: widget.fontColor,
                    ),
                  ),
                ),
                Icon(
                  showSection
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  color: widget.fontColor,
                ),
              ],
            ),
          ),
        ),
        ExpandedSection(
          expand: showSection,
          child: widget.child,
        ),
      ],
    );
  }
}
