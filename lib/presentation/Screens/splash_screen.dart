import 'package:flutter/material.dart';
import 'package:hydra_time/Routes/app_routes.dart';
import 'package:hydra_time/core/constants/prefs_keys.dart';
import 'package:hydra_time/core/services/shared_prefs_service.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  bool userOnBoard = false;

  @override
  void initState() {
    super.initState();
    getUserOnBoardDetails();
  }

  Future<void> getUserOnBoardDetails() async {
    final prefs = SharedPrefsService.instance;
    userOnBoard = prefs.getBool(PrefsKeys.onboardingComplete);
    debugPrint("User onBoard Status $userOnBoard");
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacementNamed(
      context,
      userOnBoard ? AppRoutes.dashBoard : AppRoutes.onBoarding,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/icons/HydraTimeLogo.png", height: 200),
      ),
    );
  }
}
