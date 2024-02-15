import 'package:flutter/material.dart';

class AppColors {
  static Color blue = const HSLColor.fromAHSL(1, 246, .80, .60).toColor();
  static Color lightRed = const HSLColor.fromAHSL(1, 12, 1.00, .70).toColor();
  static Color lightRed1 = const HSLColor.fromAHSL(1, 348, 1.00, .68).toColor();
  static Color softBlue = const HSLColor.fromAHSL(1, 195, .74, .62).toColor();
  static Color limeGreen = const HSLColor.fromAHSL(1, 145, 1.00, .55).toColor();
  static Color violet = const HSLColor.fromAHSL(1, 264, .64, .52).toColor();
  static Color softOrange = const HSLColor.fromAHSL(1, 43, .84, .65).toColor();
  static Color veryDarkBlue =
      const HSLColor.fromAHSL(1, 226, .43, .10).toColor();
  static Color darkBlue = const HSLColor.fromAHSL(1, 235, .46, .20).toColor();
  static Color desaturatedBlue =
      const HSLColor.fromAHSL(1, 235, .45, .61).toColor();
  static Color paleBlue = const HSLColor.fromAHSL(1, 236, 1.00, .87).toColor();
}

final appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.paleBlue),
  useMaterial3: true,
  primaryColor: AppColors.paleBlue,
  textTheme: const TextTheme(
    bodySmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.normal,
    ),
    titleMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
    ),
    displayLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w300,
    ),
  ),
);
