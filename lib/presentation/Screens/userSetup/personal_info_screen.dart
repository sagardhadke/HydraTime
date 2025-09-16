import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hydra_time/Routes/app_routes.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/core/constants/app_data.dart';
import 'package:hydra_time/core/services/logger_service.dart';
import 'package:intl/intl.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  final log = LoggerService();

  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SafeArea(
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text(
                  "Personal Info",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    fontSize: 25,
                  ),
                ),
                Text(
                  "We use this information to create a personalized hydration plan just for you.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                Text("Enter Your Name"),
                TextField(
                  controller: fullNameController,
                  style: TextStyle(color: AppColors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.grey40,
                    prefixIcon: Icon(CupertinoIcons.person),
                    hintText: 'John Dov',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.grey20, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.grey20, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.grey20, width: 2),
                    ),
                  ),
                ),
                Text("Date of Birth"),
                TextField(
                  controller: dobController,
                  style: TextStyle(color: AppColors.white),
                  readOnly: true,
                  onTap: () async {
                    final DateTime now = DateTime.now();
                    final DateTime firstDate = DateTime(now.year - 100);
                    final DateTime initialDate = DateTime(now.year - 25);
                    final DateTime lastDate = now;

                    if (Platform.isAndroid) {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: initialDate,
                        firstDate: firstDate,
                        lastDate: lastDate,
                      );
                      if (picked != null) {
                        setState(() {
                          dobController.text = DateFormat(
                            'MMM dd, yyyy',
                          ).format(picked);
                        });
                      }
                    } else {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) => Container(
                          height: 300,
                          color: Colors.black,
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerRight,
                                child: CupertinoButton(
                                  child: Text(
                                    'Done',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ),
                              Expanded(
                                child: CupertinoDatePicker(
                                  initialDateTime: initialDate,
                                  minimumDate: firstDate,
                                  maximumDate: lastDate,
                                  mode: CupertinoDatePickerMode.date,
                                  onDateTimeChanged: (DateTime newDate) {
                                    dobController.text = DateFormat(
                                      'MMM dd, yyyy',
                                    ).format(newDate);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.grey40,
                    prefixIcon: Icon(CupertinoIcons.calendar),
                    hintText: 'Select Your DOB',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.grey20, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.grey20, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.grey20, width: 2),
                    ),
                  ),
                ),
                Text("Select Your Gender"),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: AppData.genders.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                          log.d(
                            "Selected Gender $index and ${AppData.genders[index]['label']}",
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
                              AppData.genders[index]['img'],
                              height: 75,
                              width: 75,
                            ),
                            SizedBox(height: 10),
                            Text(
                              AppData.genders[index]['label'],
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedIndex == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Please Select Your Gender",
                              style: TextStyle(color: AppColors.white),
                            ),
                            backgroundColor: Colors.red,
                            showCloseIcon: true,
                            duration: Duration(seconds: 1),
                          ),
                        );
                      } else {
                        Navigator.pushNamed(context, AppRoutes.dailyRoutine);
                      }
                    },
                    child: Text("Next"),
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
