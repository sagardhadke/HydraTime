import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydra_time/core/constants/app_colors.dart';

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  primaryColor: AppColors.primaryColor,
  primaryColorLight: AppColors.primaryLight,
  primaryColorDark: AppColors.primaryDark,

  scaffoldBackgroundColor: AppColors.darkScaffold,
  canvasColor: AppColors.darkBackground,
  cardColor: AppColors.darkCard,

  colorScheme: const ColorScheme.dark(
    primary: AppColors.primaryColor,
    primaryContainer: AppColors.primaryDark,
    secondary: AppColors.primaryLight,
    secondaryContainer: AppColors.darkGrey40,
    surface: AppColors.darkSurface,
    error: AppColors.errorColor,
    onPrimary: Colors.black,
    onSecondary: Colors.white,
    onSurface: AppColors.darkTextPrimary,
    onError: Colors.white,
    brightness: Brightness.dark,
  ),

  fontFamily: 'Poppins',

  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w700,
      color: AppColors.darkTextPrimary,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w700,
      color: AppColors.darkTextPrimary,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      color: AppColors.darkTextPrimary,
    ),

    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: AppColors.darkTextPrimary,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: AppColors.darkTextPrimary,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.darkTextPrimary,
    ),

    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: AppColors.darkTextPrimary,
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.darkTextPrimary,
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.darkTextPrimary,
    ),

    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.darkTextPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.darkTextSecondary,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.darkTextTertiary,
    ),

    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.darkTextPrimary,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.darkTextSecondary,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: AppColors.darkTextTertiary,
    ),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.darkScaffold,
    foregroundColor: AppColors.darkTextPrimary,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.darkGrey100,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.darkTextPrimary,
      fontFamily: 'Poppins',
    ),
    iconTheme: IconThemeData(color: AppColors.darkTextPrimary, size: 24),
  ),

  cardTheme: CardThemeData(
    color: AppColors.darkCard,
    elevation: 2,
    shadowColor: AppColors.darkShadow,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.black,
      elevation: 2,
      shadowColor: AppColors.darkShadow,
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
      foregroundColor: AppColors.darkTextPrimary,
      highlightColor: AppColors.primaryColor.withOpacity(0.1),
    ),
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primaryColor,
    foregroundColor: Colors.black,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.darkGrey80,
    selectedItemColor: AppColors.primaryColor,
    unselectedItemColor: AppColors.darkGrey10,
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
    fillColor: AppColors.darkGrey40,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.darkGrey20, width: 1.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.darkGrey20, width: 1.5),
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
      color: AppColors.darkTextSecondary,
      fontSize: 14,
    ),
    hintStyle: const TextStyle(color: AppColors.darkTextTertiary, fontSize: 14),
    prefixIconColor: AppColors.primaryColor,
    suffixIconColor: AppColors.darkTextSecondary,
  ),

  dividerTheme: const DividerThemeData(
    color: AppColors.darkDivider,
    thickness: 1,
    space: 1,
  ),

  chipTheme: ChipThemeData(
    backgroundColor: AppColors.darkGrey40,
    selectedColor: AppColors.primaryColor,
    disabledColor: AppColors.darkGrey60,
    secondarySelectedColor: AppColors.primaryDark,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    labelStyle: const TextStyle(
      color: AppColors.darkTextPrimary,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    secondaryLabelStyle: const TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(color: AppColors.darkGrey20),
    ),
    elevation: 0,
  ),

  dialogTheme: DialogThemeData(
    backgroundColor: AppColors.darkGrey60,
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    titleTextStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.darkTextPrimary,
      fontFamily: 'Poppins',
    ),
    contentTextStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.darkTextSecondary,
      fontFamily: 'Poppins',
    ),
  ),

  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColors.darkGrey40,
    contentTextStyle: const TextStyle(
      color: AppColors.darkTextPrimary,
      fontSize: 14,
      fontFamily: 'Poppins',
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    elevation: 4,
  ),

  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.primaryColor,
    circularTrackColor: AppColors.darkGrey40,
  ),

  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primaryColor;
      }
      return AppColors.darkGrey60;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primaryColor.withOpacity(0.5);
      }
      return AppColors.darkGrey40;
    }),
  ),

  sliderTheme: const SliderThemeData(
    activeTrackColor: AppColors.primaryColor,
    inactiveTrackColor: AppColors.darkGrey40,
    thumbColor: AppColors.primaryColor,
    overlayColor: Color(0x2900B8D4),
  ),

  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppColors.darkGrey60,
    modalBackgroundColor: AppColors.darkGrey60,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
  ),

  listTileTheme: const ListTileThemeData(
    tileColor: Colors.transparent,
    selectedTileColor: Color(0x1400B8D4),
    iconColor: AppColors.darkTextPrimary,
    textColor: AppColors.darkTextPrimary,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  ),
);
