import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/core/constants/app_data.dart';
import 'package:hydra_time/core/services/logger_service.dart';

class YourActivity extends StatefulWidget {
  const YourActivity({super.key});

  @override
  State<YourActivity> createState() => _YourActivityState();
}

class _YourActivityState extends State<YourActivity> {
  final log = LoggerService();
  int? selectedAct;

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
                "Your Activity Level",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                  fontSize: 25,
                ),
              ),
              Text(
                "Select your activity level to receive a personalized hydration plan.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 5),
              ListView.builder(
                itemCount: AppData.yourActivityList.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedAct = index;
                          log.i(
                            "Selected Activities is :${AppData.yourActivityList[index]['label']}",
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
                            color: selectedAct == index
                                ? AppColors.primaryColor
                                : AppColors.grey80,
                            width: 2,
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            AppData.yourActivityList[index]['label'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            AppData.yourActivityList[index]['desc'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          leading: Image.asset(
                            AppData.yourActivityList[index]['img'],
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
                    if (selectedAct == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Please Select Your Activity Level",
                            style: TextStyle(color: AppColors.white),
                          ),
                          backgroundColor: Colors.red,
                          showCloseIcon: true,
                          duration: Duration(seconds: 1),
                        ),
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
