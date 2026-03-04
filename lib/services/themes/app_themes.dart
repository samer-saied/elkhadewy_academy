import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class AppThemes {
  static const Color primaryColor = Color(0xFFD69E33);

  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'Cairo',
      brightness: Brightness.light,
      primaryColor: const Color(0xFFD69E33),
      scaffoldBackgroundColor: AppColors.softGrey,

      colorScheme: ColorScheme.fromSeed(
        primary: primaryColor,
        seedColor: AppColors.jonquilLight,
        brightness: Brightness.light,
        secondary: AppColors.jonquil,
        surface: AppColors.whiteColor,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: AppColors.whiteColor,
        elevation: 1,
        titleTextStyle: const TextStyle(
          color: AppColors.whiteColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          minimumSize: const Size(double.infinity, 50),

          foregroundColor: AppColors.whiteColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),

          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 2,
        ),
      ),

      cardTheme: CardThemeData(
        // elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      ),

      textSelectionTheme: TextSelectionThemeData(
        cursorColor: primaryColor,
        selectionColor: primaryColor.withAlpha(50),
        selectionHandleColor: primaryColor,
      ),
    );
  }

  static ThemeData get darkTheme {
    const Color darkSurface = AppColors.midBlackColor;
    const Color darkScaffoldBackground = AppColors.blackColor;

    return ThemeData(
      fontFamily: 'Cairo',
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkScaffoldBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary: primaryColor,
        onPrimary: AppColors.whiteColor,
        secondary: AppColors.emerald,
        surface: darkSurface,
      ),

      // Ensure text colors are visible on dark backgrounds.
      textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: AppColors.whiteColor,
        displayColor: AppColors.whiteColor,
      ),
      primaryTextTheme: ThemeData.dark().primaryTextTheme.apply(
        bodyColor: AppColors.whiteColor,
        displayColor: AppColors.whiteColor,
      ),
      iconTheme: const IconThemeData(color: AppColors.whiteColor),
      primaryIconTheme: const IconThemeData(color: AppColors.whiteColor),

      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: AppColors.whiteColor,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.whiteColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // bottomAppBarTheme: BottomAppBarThemeData(color: AppColors.blackColor),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: AppColors.whiteColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.lightGrey),
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // textSelectionTheme: TextSelectionThemeData(
      //   cursorColor: primaryColor,
      //   selectionColor: primaryColor..withAlpha(50),
      //   selectionHandleColor: primaryColor,
      // ),
    );
  }
}
