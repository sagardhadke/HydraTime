import 'package:flutter/material.dart';
import 'package:hydra_time/Routes/app_routes.dart';
import 'package:hydra_time/core/services/notification_service.dart';
import 'package:hydra_time/core/services/shared_prefs_service.dart';
import 'package:hydra_time/core/theme/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsService.instance.init();
  await NotificationService().initNotification();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.mRoutes,
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
    );
  }
}
