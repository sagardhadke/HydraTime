import 'package:flutter/material.dart';
import 'package:hydra_time/Routes/app_routes.dart';
import 'package:hydra_time/core/constants/app_colors.dart';

class PreparingYourPlan extends StatefulWidget {
  const PreparingYourPlan({super.key});

  @override
  State<PreparingYourPlan> createState() => _PreparingYourPlanState();
}

class _PreparingYourPlanState extends State<PreparingYourPlan> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), (){
      Navigator.pushReplacementNamed(context, AppRoutes.waterSuggestion);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                Image.asset(
                  "assets/images/preparing_plan.png",
                  height: 200,
                  width: 200,
                ),
                Text(
                  "Preparing your plan",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                    color: AppColors.primaryColor,
                  ),
                ),
                Text(
                  "Setting up your water plan and analyzing your goals...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 10),
                const CircularProgressIndicator(
                  color: AppColors.primaryColor,
                  strokeWidth: 3.5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
