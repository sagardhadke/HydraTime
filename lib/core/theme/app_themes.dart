export 'dark_theme.dart';
export 'light_theme.dart';
export 'theme_provider.dart';
export 'models/theme_settings_model.dart';

//* v1 old

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
  appBarTheme: AppBarTheme(backgroundColor: AppColors.scaffoldDark),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.black,
      textStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: Colors.black,
      ),
    ),
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color(0XFF282727),
    selectedItemColor: AppColors.primaryColor,
    unselectedItemColor: Colors.grey,
    showUnselectedLabels: true,
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
    elevation: 8,
  ),
);
