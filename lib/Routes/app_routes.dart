import 'package:flutter/material.dart';
import 'package:hydra_time/presentation/Screens/Onboarding/onBoarding.dart';
import 'package:hydra_time/presentation/Screens/Reminder/intervals_remainder.dart';
import 'package:hydra_time/presentation/Screens/Reminder/setup_remainder.dart';
import 'package:hydra_time/presentation/Screens/Reminder/specific_remainder.dart';
import 'package:hydra_time/presentation/Screens/about_us.dart';
import 'package:hydra_time/presentation/Screens/dashboard.dart';
import 'package:hydra_time/presentation/Screens/home_screen.dart';
import 'package:hydra_time/presentation/Screens/Reminder/reminder_screen.dart';
import 'package:hydra_time/presentation/Screens/settings_screen.dart';
import 'package:hydra_time/presentation/Screens/splash_screen.dart';
import 'package:hydra_time/presentation/Screens/userSetup/daily_routine_screen.dart';
import 'package:hydra_time/presentation/Screens/userSetup/personal_info_screen.dart';
import 'package:hydra_time/presentation/Screens/userSetup/preparing_your_plan.dart';
import 'package:hydra_time/presentation/Screens/userSetup/water_suggestion.dart';
import 'package:hydra_time/presentation/Screens/userSetup/your_activity.dart';
import 'package:hydra_time/presentation/Screens/userSetup/your_climate.dart';

class AppRoutes {
  static const String home = '/home';
  static const String splash = '/splash';
  static const String onBoarding = '/onBoarding';
  static const String dashBoard = '/dashBoard';
  static const String personalInfo = '/personalInfo';
  static const String dailyRoutine = '/dailyRoutine';
  static const String yourActivity = '/yourActivity';
  static const String yourClimate = '/yourClimate';
  static const String preparingYourPlan = '/preparingYourPlan';
  static const String waterSuggestion = '/waterSuggestion';
  static const String reminder = '/reminder';
  static const String settings = '/settings';
  static const String aboutUs = '/aboutUs';
  static const String setupRemainder = '/setupRemainder';
  static const String intervalsReminder = '/intervalsReminder';
  static const String specificReminder = '/specificReminder';

  static Map<String, WidgetBuilder> mRoutes = {
    AppRoutes.splash: (_) => MySplashScreen(),
    AppRoutes.onBoarding: (_) => MyOnBoardingScreen(),
    AppRoutes.dashBoard: (_) => MyDashBoard(),
    AppRoutes.personalInfo: (_) => PersonalInfo(),
    AppRoutes.dailyRoutine: (_) => DailyRoutine(),
    AppRoutes.yourActivity: (_) => YourActivity(),
    AppRoutes.yourClimate: (_) => YourClimate(),
    AppRoutes.preparingYourPlan: (_) => PreparingYourPlan(),
    AppRoutes.waterSuggestion : (_) => WaterSuggestion(),
    AppRoutes.home : (_) => MyHomeScreen(),
    AppRoutes.reminder : (_) => MyReminderScreen(),
    AppRoutes.settings : (_) => MySettingsScreen(),
    AppRoutes.aboutUs : (_) => AboutUsScreen(),
    AppRoutes.setupRemainder : (_) => SetupRemainder(),
    AppRoutes.intervalsReminder : (_) => IntervalsRemainder(),
    AppRoutes.specificReminder : (_) => SpecificRemainder(),
  };
}
