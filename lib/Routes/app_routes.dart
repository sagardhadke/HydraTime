import 'package:flutter/material.dart';
import 'package:hydra_time/presentation/Screens/splash_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String splash = '/splash';

  static Map<String, WidgetBuilder> mRoutes = {
    AppRoutes.splash: (_) => MySplashScreen(),
  };
}
