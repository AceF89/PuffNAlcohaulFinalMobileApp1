import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_font_family.dart';

class ThemeUtils {
  ThemeUtils._();

  static ThemeData get theme {
    return ThemeData(
      primaryColor: AppColors.primaryColor,
      hintColor: AppColors.hintColor,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      fontFamily: AppFontFamily.poppins,
      splashColor: Colors.white.withOpacity(0.1),
      highlightColor: Colors.white.withOpacity(0.1),
      unselectedWidgetColor: Colors.grey.shade400,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.primaryColor,
        selectionColor: AppColors.primaryColor.withOpacity(0.1),
        selectionHandleColor: AppColors.primaryColor,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: generateMaterialColor(AppColors.primaryColor),
      ).copyWith(secondary: AppColors.primaryColor).copyWith(surface: AppColors.backgroundColor),
    );
  }

  static MaterialColor generateMaterialColor(Color color) {
    return MaterialColor(color.value, {
      50: color,
      100: color,
      200: color,
      300: color,
      400: color,
      500: color,
      600: color,
      700: color,
      800: color,
      900: color,
    });
  }
}
