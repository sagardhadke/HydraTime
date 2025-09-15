import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/app_colors.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Poppins',
  primaryColor: Color(0XFF00B8D4),
  scaffoldBackgroundColor: AppColors.scaffoldDark,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontWeight: FontWeight.w400, fontSize: 16), // Regular
    bodyMedium: TextStyle(fontWeight: FontWeight.w500, fontSize: 14), // Medium
    titleMedium: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 18,
    ), // SemiBold
    titleLarge: TextStyle(fontWeight: FontWeight.w700, fontSize: 20), // Bold
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
    ),
  ),
);
