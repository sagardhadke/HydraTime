import 'package:flutter/material.dart';
import 'package:hydra_time/features/onboarding/presentation/pages/onboarding_screen.dart';
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
    AppRoutes.splash: (_) => const MySplashScreen(),
    AppRoutes.onBoarding: (_) => const OnboardingScreen(),
    AppRoutes.dashBoard: (_) => const MyDashBoard(),
    AppRoutes.personalInfo: (_) => const PersonalInfo(),
    AppRoutes.dailyRoutine: (_) => const DailyRoutine(),
    AppRoutes.yourActivity: (_) => const YourActivity(),
    AppRoutes.yourClimate: (_) => const YourClimate(),
    AppRoutes.preparingYourPlan: (_) => const PreparingYourPlan(),
    AppRoutes.waterSuggestion: (_) => const WaterSuggestion(),
    AppRoutes.home: (_) => const MyHomeScreen(),
    AppRoutes.reminder: (_) => const MyReminderScreen(),
    AppRoutes.settings: (_) => const MySettingsScreen(),
    AppRoutes.aboutUs: (_) => const AboutUsScreen(),
    AppRoutes.setupRemainder: (_) => const SetupRemainder(),
    AppRoutes.intervalsReminder: (_) => const IntervalsRemainder(),
    AppRoutes.specificReminder: (_) => const SpecificRemainder(),
  };
}
