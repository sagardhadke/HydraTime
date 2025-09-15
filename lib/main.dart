import 'package:flutter/material.dart';
import 'package:hydra_time/Routes/app_routes.dart';
import 'package:hydra_time/core/theme/app_themes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRoutes.onBoarding,
      routes: AppRoutes.mRoutes,
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
    );
  }
}
