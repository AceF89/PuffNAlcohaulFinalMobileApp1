import 'package:alcoholdeliver/core/utils/screen_util.dart';
import 'package:flutter/material.dart';

class HomepageBackground extends StatelessWidget {
  final Widget? child;
  final bool useBackground;

  const HomepageBackground({
    super.key,
    this.child,
    this.useBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!useBackground) return SafeArea(child: child ?? const SizedBox());

    return SafeArea(
      child: Stack(
        children: [
          // Container(
          //   color: Colors.white,
          //   height: ScreenUtil().screenHeight,
          //   child: Column(
          //     children: [
          //       Image.asset(
          //         AppAssets.halfCircle2,
          //         filterQuality: FilterQuality.high,
          //         width: ScreenUtil().screenWidth / 1.8,
          //       ),
          //     ],
          //   ),
          // ),
          SizedBox(
            height: ScreenUtil().screenHeight,
            width: ScreenUtil().screenWidth,
            child: child,
          ),
        ],
      ),
    );
  }
}
