import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hydra_time/Routes/app_routes.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/core/constants/prefs_keys.dart';
import 'package:hydra_time/core/services/shared_prefs_service.dart';

class MySettingsScreen extends StatefulWidget {
  const MySettingsScreen({super.key});

  @override
  State<MySettingsScreen> createState() => _MySettingsScreenState();
}

class _MySettingsScreenState extends State<MySettingsScreen> {
  double? dailyTarget;
  String age = '';
  String weight = '';
  String height = '';
  String gender = '';
  String activity = '';
  String climate = '';

  List<Map<String, dynamic>> personalInfo = [];

  @override
  void initState() {
    super.initState();
    getUserOnBoardDetails();
  }

  Future<void> getUserOnBoardDetails() async {
    final prefs = SharedPrefsService.instance;

    final double target = prefs.getDouble(
      PrefsKeys.dailyTarget,
      defaultValue: 3000.0,
    );
    final String dob = prefs.getString(
      PrefsKeys.dob,
      defaultValue: 'Jan 01, 2000',
    ).isNotEmpty ? prefs.getString(PrefsKeys.dob) : 'Jan 01, 2000';
    final String userWeight = prefs.getString(
      PrefsKeys.weight,
      defaultValue: '70',
    ).isNotEmpty ? prefs.getString(PrefsKeys.weight) : '70';
    final String userHeight = prefs.getString(
      PrefsKeys.height,
      defaultValue: '170',
    ).isNotEmpty ? prefs.getString(PrefsKeys.height) : '170';
    final String userGender = prefs.getString(
      PrefsKeys.gender,
      defaultValue: 'Male',
    );
    final String userActivity = prefs.getString(
      PrefsKeys.activity,
      defaultValue: 'Active',
    );
    final String userClimate = prefs.getString(
      PrefsKeys.climate,
      defaultValue: 'Cold',
    );

    setState(() {
      dailyTarget = target;
      age = dob;
      weight = userWeight;
      height = userHeight;
      gender = userGender;
      activity = userActivity;
      climate = userClimate;

      personalInfo = [
        {
          "icon": CupertinoIcons.drop,
          "label": "Daily Target",
          "value": "${dailyTarget!.toStringAsFixed(0)} ml",
        },
        {"icon": CupertinoIcons.calendar, "label": "Age", "value": age},
        {
          "icon": CupertinoIcons.square_favorites,
          "label": "Weight",
          "value": "$weight kg",
        },
        {"icon": Icons.height, "label": "Height", "value": "$height cm"},
        {"icon": CupertinoIcons.person, "label": "Gender", "value": gender},
        {
          "icon": CupertinoIcons.waveform,
          "label": "Activity Level",
          "value": activity,
        },
        {
          "icon": CupertinoIcons.cloud_sun,
          "label": "Climate",
          "value": climate,
        },
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(scrolledUnderElevation: 0, title: const Text("Settings")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 15,
              children: [
                Text(
                  "Personal Information",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    fontSize: 18,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: personalInfo.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.grey60,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          title: Text(
                            personalInfo[index]['label'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            personalInfo[index]['value'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          leading: Icon(
                            personalInfo[index]['icon'] as IconData,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await SharedPrefsService.instance.clear();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.onBoarding,
                        (route) => false,
                      );
                    },
                    child: Text("Sign out"),
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
