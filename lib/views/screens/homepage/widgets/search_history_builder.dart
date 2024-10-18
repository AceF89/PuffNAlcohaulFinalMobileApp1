import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchHistoryBuilder extends StatelessWidget {
  const SearchHistoryBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizes.s200,
      child: ListView.builder(
        itemCount: 20,
        itemBuilder: (ctx, _) {
          return Container(
            margin: const EdgeInsets.only(bottom: Sizes.s20),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppAssets.icClock,
                  height: Sizes.s20.h,
                  width: Sizes.s20.w,
                ),
                SizedBoxW10(),
                Text(
                  'Somehthing',
                  style: TextStyle(
                    fontSize: Sizes.s16.sp,
                  ),
                ),
                const Spacer(),
                SvgPicture.asset(
                  AppAssets.icCancel,
                  height: Sizes.s20.h,
                  width: Sizes.s20.w,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
