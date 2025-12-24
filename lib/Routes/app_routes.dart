import 'package:flutter/material.dart';
import 'package:hydra_time/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:hydra_time/features/user_profile/presentation/pages/activity_screen.dart';
import 'package:hydra_time/features/user_profile/presentation/pages/climate_screen.dart';
import 'package:hydra_time/features/user_profile/presentation/pages/daily_routine_screen.dart';
import 'package:hydra_time/features/user_profile/presentation/pages/personal_info_screen.dart';
import 'package:hydra_time/features/user_profile/presentation/pages/preparing_plan_screen.dart';
import 'package:hydra_time/features/user_profile/presentation/pages/water_suggestion_screen.dart';
import 'package:hydra_time/presentation/Screens/Reminder/intervals_remainder.dart';
import 'package:hydra_time/presentation/Screens/Reminder/setup_remainder.dart';
import 'package:hydra_time/presentation/Screens/Reminder/specific_remainder.dart';
import 'package:hydra_time/presentation/Screens/about_us.dart';
import 'package:hydra_time/presentation/Screens/dashboard.dart';
import 'package:hydra_time/presentation/Screens/home_screen.dart';
import 'package:hydra_time/presentation/Screens/Reminder/reminder_screen.dart';
import 'package:hydra_time/presentation/Screens/settings_screen.dart';
import 'package:hydra_time/presentation/Screens/splash_screen.dart';

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
    AppRoutes.personalInfo: (_) => const PersonalInfoScreen(),
    AppRoutes.dailyRoutine: (_) => const DailyRoutineScreen(),
    AppRoutes.yourActivity: (_) => const ActivityScreen(),
    AppRoutes.yourClimate: (_) => const ClimateScreen(),
    AppRoutes.preparingYourPlan: (_) => const PreparingPlanScreen(),
    AppRoutes.waterSuggestion: (_) => const WaterSuggestionScreen(),
    AppRoutes.home: (_) => const MyHomeScreen(),
    AppRoutes.reminder: (_) => const MyReminderScreen(),
    AppRoutes.settings: (_) => const MySettingsScreen(),
    AppRoutes.aboutUs: (_) => const AboutUsScreen(),
    AppRoutes.setupRemainder: (_) => const SetupRemainder(),
    AppRoutes.intervalsReminder: (_) => const IntervalsRemainder(),
    AppRoutes.specificReminder: (_) => const SpecificRemainder(),
  };
}
