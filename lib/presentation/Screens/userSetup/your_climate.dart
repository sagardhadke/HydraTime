import 'package:flutter/material.dart';
import 'package:hydra_time/Routes/app_routes.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/core/constants/app_data.dart';
import 'package:hydra_time/core/services/logger_service.dart';

class YourClimate extends StatefulWidget {
  const YourClimate({super.key});

  @override
  State<YourClimate> createState() => _YourClimateState();
}

class _YourClimateState extends State<YourClimate> {
  final log = LoggerService();
  int? selectedClimate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(scrolledUnderElevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your Climate",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                  fontSize: 25,
                ),
              ),
              Text(
                "Select the climate you live in to help us personalize your hydration plan.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 5),
              ListView.builder(
                itemCount: AppData.yourClimateList.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedClimate = index;
                          log.i(
                            "Selected Activities is :${AppData.yourClimateList[index]['label']}",
                          );
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.grey40,
                          borderRadius: BorderRadius.circular(15),
                          border: BoxBorder.all(
                            color: selectedClimate == index
                                ? AppColors.primaryColor
                                : AppColors.grey80,
                            width: 2,
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            AppData.yourClimateList[index]['label'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            AppData.yourClimateList[index]['desc'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          leading: Image.asset(
                            AppData.yourClimateList[index]['img'],
                            height: 32,
                            width: 32,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedClimate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Please Select Your Climate",
                            style: TextStyle(color: AppColors.white),
                          ),
                          backgroundColor: Colors.red,
                          showCloseIcon: true,
                          duration: Duration(seconds: 1),
                        ),
                      );
                    } else {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.preparingYourPlan,
                        (route) => false,
                      );
                    }
                  },
                  child: Text("Next"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
