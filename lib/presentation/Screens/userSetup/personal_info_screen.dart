import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:intl/intl.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
            ],
          ),
        ),
      ),
    );
  }
}
