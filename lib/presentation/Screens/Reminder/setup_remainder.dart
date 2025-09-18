import 'package:flutter/material.dart';
import 'package:hydra_time/Routes/app_routes.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/core/constants/app_data.dart';
import 'package:hydra_time/core/services/logger_service.dart';

class SetupRemainder extends StatefulWidget {
  const SetupRemainder({super.key});

  @override
  State<SetupRemainder> createState() => _SetupRemainderState();
}

class _SetupRemainderState extends State<SetupRemainder> {
  final log = LoggerService();
  int? selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text("Setup Reminder"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 15),
              Text(
                "What type of remainder do you want to create?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 21,
                ),
              ),
              SizedBox(height: 50),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: AppData.remainder.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        log.d(
                          "Selected Reminder $index and ${AppData.remainder[index]['label']}",
                        );
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 25),
                      decoration: BoxDecoration(
                        color: AppColors.grey40,
                        borderRadius: BorderRadius.circular(15),
                        border: BoxBorder.all(
                          color: selectedIndex == index
                              ? AppColors.primaryColor
                              : AppColors.grey80,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppData.remainder[index]['img'],
                            height: 75,
                            width: 75,
                          ),
                          SizedBox(height: 10),
                          Text(
                            AppData.remainder[index]['label'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    if (selectedIndex == 0) {
                      Navigator.pushNamed(context, AppRoutes.intervalsReminder);
                    } else {
                      Navigator.pushNamed(context, AppRoutes.specificReminder);
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
