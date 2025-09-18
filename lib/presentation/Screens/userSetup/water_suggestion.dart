import 'package:flutter/material.dart';
import 'package:hydra_time/Routes/app_routes.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/core/constants/prefs_keys.dart';
import 'package:hydra_time/core/services/shared_prefs_service.dart';

class WaterSuggestion extends StatefulWidget {
  const WaterSuggestion({super.key});

  @override
  State<WaterSuggestion> createState() => _WaterSuggestionState();
}

class _WaterSuggestionState extends State<WaterSuggestion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                Text(
                  "Our Suggestion",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
                ),
                Text(
                  "Based on your inputs, we recommend you to drink 3 liters of fluid every day.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  height: 120,
                  width: 120,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 25),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(15),
                      border: BoxBorder.all(color: AppColors.grey40, width: 2),
                    ),
                    child: Text(
                      "3.0L",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "⚠️ More water kills",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.redAccent,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final prefs = SharedPrefsService.instance;
                      await prefs.setDouble(PrefsKeys.dailyTarget, 3000.0);
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.dashBoard,
                      );
                    },
                    child: Text("Get Started"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
