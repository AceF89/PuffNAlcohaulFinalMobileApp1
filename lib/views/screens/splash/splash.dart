import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/utils/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToNext();
    });
  }

  void _navigateToNext() {
    Future.delayed(const Duration(seconds: 3), () {
      if (preferences.isLoggedIn) {
        Navigator.pushReplacementNamed(context, Routes.mainHome);
      } else {
        Navigator.pushReplacementNamed(context, Routes.loginScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight,
        child: Lottie.asset(
          AppAssets.splashAnimation,
          width: ScreenUtil().screenWidth,
          height: ScreenUtil().screenHeight,
        ),
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Text(
        //       'Welcome to',
        //       style: TextStyle(
        //         fontSize: Sizes.s18.sp,
        //         fontWeight: FontWeight.w600,
        //         color: AppColors.splashFontColor,
        //       ),
        //     ),
        //     Text(
        //       'Puff N\' Alcohaul',
        //       style: TextStyle(
        //         fontSize: Sizes.s22.sp,
        //         fontWeight: FontWeight.w600,
        //         color: AppColors.splashFontColor,
        //       ),
        //     ),
        //     Lottie.asset(
        //       AppAssets.splashAnimation,
        //       width: ScreenUtil().screenWidth,
        //       // height: Sizes.s400.sp,
        //     ),
        //     Text(
        //       'Hauling Good Times to You!',
        //       style: TextStyle(
        //         fontSize: Sizes.s20.sp,
        //         fontWeight: FontWeight.w600,
        //         color: AppColors.splashFontColor,
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
