import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:intl/intl.dart';

class DailyRoutine extends StatefulWidget {
  const DailyRoutine({super.key});

  @override
  State<DailyRoutine> createState() => _DailyRoutineState();
}

class _DailyRoutineState extends State<DailyRoutine> {
  TextEditingController wakeUpTimeController = TextEditingController();
  TextEditingController bedTimeController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  TimeOfDay wakeUpTime = TimeOfDay(hour: 7, minute: 0);
  TimeOfDay bedTime = TimeOfDay(hour: 22, minute: 0);

  bool isIos = false;

  @override
  void initState() {
    super.initState();
    isIos = Platform.isIOS;
  }

  _showTimePicker({
    required TimeOfDay initialTime,
    required Function(TimeOfDay) onConfirm,
  }) {
    Navigator.of(context).push(
      showPicker(
        context: context,
        accentColor: Colors.blueAccent,
        backgroundColor: AppColors.grey60,
        value: Time(hour: initialTime.hour, minute: initialTime.minute),
        is24HrFormat: false,
        iosStylePicker: isIos,
        okStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        cancelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        onChange: (Time newTime) {
          final picked = TimeOfDay(hour: newTime.hour, minute: newTime.minute);
          onConfirm(picked);
        },
        okText: "Done",
        cancelText: "Cancel",
      ),
    );
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Daily Routine & Body Info",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                  fontSize: 25,
                ),
              ),
              Text(
                "This helps us understand your daily habits and body stats.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
              Text("Weak-Up Time"),
              TextField(
                controller: wakeUpTimeController,
                style: TextStyle(color: AppColors.white),
                readOnly: true,
                onTap: () => _showTimePicker(
                  initialTime: wakeUpTime,
                  onConfirm: (value) {
                    setState(() {
                      wakeUpTime = value;
                      wakeUpTimeController.text = formatTimeOfDay(value);
                    });
                  },
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.grey40,
                  prefixIcon: Icon(Icons.wb_twilight),
                  hintText: 'Select Weak-up Time',
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
              Text("Bed Time"),
              TextField(
                controller: bedTimeController,
                style: TextStyle(color: AppColors.white),
                readOnly: true,
                onTap: () => _showTimePicker(
                  initialTime: bedTime,
                  onConfirm: (value) {
                    setState(() {
                      bedTime = value;
                      bedTimeController.text = formatTimeOfDay(value);
                    });
                  },
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.grey40,
                  prefixIcon: Icon(CupertinoIcons.moon),
                  hintText: 'Select Weak-up Time',
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
              Text("Height"),
              TextField(
                controller: heightController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(color: AppColors.white),
                maxLength: 3,
                decoration: InputDecoration(
                  filled: true,
                  counterText: '',
                  suffixText: 'cm',
                  fillColor: AppColors.grey40,
                  prefixIcon: Icon(Icons.height),
                  hintText: 'Enter your height',
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
              Text("Weight"),
              TextField(
                controller: weightController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(color: AppColors.white),
                maxLength: 3,
                decoration: InputDecoration(
                  filled: true,
                  suffixText: 'kg',
                  counterText: '',
                  fillColor: AppColors.grey40,
                  prefixIcon: Icon(Icons.fitness_center),
                  hintText: 'Enter your weight',
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
              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () {}, child: Text("Next")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
