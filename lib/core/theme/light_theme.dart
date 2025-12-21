import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydra_time/core/constants/app_colors.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  primaryColor: AppColors.primaryColor,
  primaryColorLight: AppColors.primaryLight,
  primaryColorDark: AppColors.primaryDark,

  scaffoldBackgroundColor: AppColors.lightScaffold,
  canvasColor: AppColors.lightBackground,
  cardColor: AppColors.lightCard,

  colorScheme: const ColorScheme.light(
    primary: AppColors.primaryColor,
    primaryContainer: AppColors.primaryLight,
    secondary: AppColors.primaryDark,
    secondaryContainer: AppColors.lightGrey20,
    surface: AppColors.lightSurface,
    error: AppColors.errorColor,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.lightTextPrimary,
    onError: Colors.white,
    brightness: Brightness.light,
  ),

  fontFamily: 'Poppins',

  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w700,
      color: AppColors.lightTextPrimary,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w700,
      color: AppColors.lightTextPrimary,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      color: AppColors.lightTextPrimary,
    ),

    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: AppColors.lightTextPrimary,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: AppColors.lightTextPrimary,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.lightTextPrimary,
    ),

    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: AppColors.lightTextPrimary,
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.lightTextPrimary,
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.lightTextPrimary,
    ),

    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.lightTextPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.lightTextSecondary,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.lightTextTertiary,
    ),

    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.lightTextPrimary,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.lightTextSecondary,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: AppColors.lightTextTertiary,
    ),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.lightBackground,
    foregroundColor: AppColors.lightTextPrimary,
    elevation: 0,
    scrolledUnderElevation: 2,
    shadowColor: AppColors.lightShadow,
    centerTitle: false,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.lightBackground,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.lightTextPrimary,
      fontFamily: 'Poppins',
    ),
    iconTheme: IconThemeData(color: AppColors.lightTextPrimary, size: 24),
  ),

  cardTheme: CardThemeData(
    color: AppColors.lightCard,
    elevation: 2,
    shadowColor: AppColors.lightShadow,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
      shadowColor: AppColors.lightShadow,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
      ),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
      ),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primaryColor,
      side: const BorderSide(color: AppColors.primaryColor, width: 2),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
      ),
    ),
  ),

  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      foregroundColor: AppColors.lightTextPrimary,
      highlightColor: AppColors.primaryColor.withOpacity(0.1),
    ),
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primaryColor,
    foregroundColor: Colors.white,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.lightBackground,
    selectedItemColor: AppColors.primaryColor,
    unselectedItemColor: AppColors.lightGrey80,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
    selectedLabelStyle: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 12,
      fontFamily: 'Poppins',
    ),
    unselectedLabelStyle: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
      fontFamily: 'Poppins',
    ),
    showSelectedLabels: true,
    showUnselectedLabels: true,
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.lightGrey10,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.lightGrey40, width: 1.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.lightGrey40, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.errorColor, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.errorColor, width: 2),
    ),
    labelStyle: const TextStyle(
      color: AppColors.lightTextSecondary,
      fontSize: 14,
    ),
    hintStyle: const TextStyle(
      color: AppColors.lightTextTertiary,
      fontSize: 14,
    ),
    prefixIconColor: AppColors.primaryColor,
    suffixIconColor: AppColors.lightTextSecondary,
  ),

  dividerTheme: const DividerThemeData(
    color: AppColors.lightDivider,
    thickness: 1,
    space: 1,
  ),

  chipTheme: ChipThemeData(
    backgroundColor: AppColors.lightGrey20,
    selectedColor: AppColors.primaryColor,
    disabledColor: AppColors.lightGrey10,
    secondarySelectedColor: AppColors.primaryLight,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    labelStyle: const TextStyle(
      color: AppColors.lightTextPrimary,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    secondaryLabelStyle: const TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(color: AppColors.lightGrey40),
    ),
    elevation: 0,
  ),

  dialogTheme: DialogThemeData(
    backgroundColor: AppColors.lightBackground,
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    titleTextStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.lightTextPrimary,
      fontFamily: 'Poppins',
    ),
    contentTextStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.lightTextSecondary,
      fontFamily: 'Poppins',
    ),
  ),

  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColors.lightTextPrimary,
    contentTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontFamily: 'Poppins',
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    elevation: 4,
  ),

  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.primaryColor,
    circularTrackColor: AppColors.lightGrey20,
  ),

  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primaryColor;
      }
      return AppColors.lightGrey60;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primaryColor.withOpacity(0.5);
      }
      return AppColors.lightGrey40;
    }),
  ),

  sliderTheme: const SliderThemeData(
    activeTrackColor: AppColors.primaryColor,
    inactiveTrackColor: AppColors.lightGrey40,
    thumbColor: AppColors.primaryColor,
    overlayColor: Color(0x2900B8D4),
  ),

  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppColors.lightBackground,
    modalBackgroundColor: AppColors.lightBackground,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
  ),

  listTileTheme: const ListTileThemeData(
    tileColor: Colors.transparent,
    selectedTileColor: Color(0x1400B8D4),
    iconColor: AppColors.lightTextPrimary,
    textColor: AppColors.lightTextPrimary,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  ),
);
