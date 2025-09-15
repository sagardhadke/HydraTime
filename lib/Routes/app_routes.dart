import 'package:flutter/material.dart';
import 'package:hydra_time/presentation/Screens/Onboarding/onBoarding.dart';
import 'package:hydra_time/presentation/Screens/dashboard.dart';
import 'package:hydra_time/presentation/Screens/splash_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String splash = '/splash';
  static const String onBoarding = '/onBoarding';
  static const String dashBoard = '/dashBoard';

  static Map<String, WidgetBuilder> mRoutes = {
    AppRoutes.splash: (_) => MySplashScreen(),
    AppRoutes.onBoarding : (_) => MyOnBoardingScreen(),
    AppRoutes.dashBoard : (_) => MyDashBoard()
  };
}
