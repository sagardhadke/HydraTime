import 'dart:convert';
import 'dart:io';

import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/core/constants/app_data.dart';
import 'package:hydra_time/core/constants/prefs_keys.dart';
import 'package:hydra_time/core/models/reminderModel.dart';
import 'package:hydra_time/core/services/logger_service.dart';
import 'package:hydra_time/core/services/notification_service.dart';
import 'package:hydra_time/core/services/shared_prefs_service.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class SpecificRemainder extends StatefulWidget {
  const SpecificRemainder({super.key});

  @override
  State<SpecificRemainder> createState() => SpecificRemainderState();
}

class SpecificRemainderState extends State<SpecificRemainder> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController specificTimeController = TextEditingController();

  DateTime nowTime = DateTime.now();

  final log = LoggerService();

  int? selectedTitleIndex;
  int? selectedDescIndex;

  bool isIos = false;

  @override
  void initState() {
    super.initState();
    isIos = Platform.isIOS;
  }

  showTimePicker({
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
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text("Specific Time Reminder"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                "Title",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: titleController,
                style: TextStyle(color: AppColors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.grey40,
                  prefixIcon: Icon(Icons.title),
                  hintText: 'Write your title here',
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
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(AppData.reminderTitle.length, (index) {
                  final item = AppData.reminderTitle[index];
                  return ChoiceChip(
                    label: Text(item),
                    selected: selectedTitleIndex == index,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedTitleIndex = selected ? index : null;
                        titleController.text = item;
                      });
                      log.d("Selected Reminder Title: $item");
                    },
                    selectedColor: AppColors.primaryColor,
                    backgroundColor: AppColors.grey40,
                    labelStyle: TextStyle(
                      color: selectedTitleIndex == index
                          ? Colors.white
                          : Colors.grey[300],
                    ),
                  );
                }),
              ),
              const Text(
                "Description",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: descController,
                style: TextStyle(color: AppColors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.grey40,
                  prefixIcon: Icon(Icons.title),
                  hintText: 'Write your title here',
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
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(AppData.reminderDesc.length, (index) {
                  final item = AppData.reminderDesc[index];
                  return ChoiceChip(
                    label: Text(item),
                    selected: selectedDescIndex == index,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedDescIndex = selected ? index : null;
                        descController.text = item;
                      });
                      log.d("Selected Reminder Description: $item");
                    },
                    selectedColor: AppColors.primaryColor,
                    backgroundColor: AppColors.grey40,
                    labelStyle: TextStyle(
                      color: selectedDescIndex == index
                          ? Colors.white
                          : Colors.grey[300],
                    ),
                  );
                }),
              ),
              Text(
                "Time",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: specificTimeController,
                style: TextStyle(color: AppColors.white),
                readOnly: true,
                onTap: () => showTimePicker(
                  initialTime: TimeOfDay.now(),
                  onConfirm: (value) {
                    setState(() {
                      nowTime = DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        value.hour,
                        value.minute,
                      );
                      specificTimeController.text = formatTimeOfDay(value);
                    });
                  },
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.grey40,
                  prefixIcon: Icon(Icons.wb_twilight),
                  hintText: 'Select Time',
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
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.trim().isEmpty ||
                        descController.text.trim().isEmpty ||
                        specificTimeController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Please fill in all fields",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final prefs = SharedPrefsService.instance;

                    final int id =
                        DateTime.now().millisecondsSinceEpoch ~/ 1000;

                    final reminder = ReminderModel(
                      id: id,
                      title: titleController.text.trim(),
                      description: descController.text.trim(),
                      interval: specificTimeController.text.trim(),
                    );

                    try {
                      final existingList = prefs.getStringList(
                        PrefsKeys.intervalsReminderList,
                      );
                      final modifiableList = [...existingList];

                      modifiableList.add(jsonEncode(reminder.toJson()));
                      await prefs.setStringList(
                        PrefsKeys.intervalsReminderList,
                        modifiableList,
                      );

                      final now = tz.TZDateTime.now(tz.local);

                      tz.TZDateTime scheduledDate = tz.TZDateTime(
                        tz.local,
                        now.year,
                        now.month,
                        now.day,
                        nowTime.hour,
                        nowTime.minute,
                      );

                      if (scheduledDate.isBefore(now)) {
                        scheduledDate = scheduledDate.add(Duration(days: 1));
                      }

                      final notificationService = NotificationService();

                      await notificationService.scheduleReminder(
                        id: id,
                        title: reminder.title,
                        body: reminder.description,
                        scheduledDate: scheduledDate,
                        payload: jsonEncode(reminder.toJson()),
                      );

                      await notificationService.instantNotification(
                        id: id + 1,
                        title: "Reminder Set Successfully",
                        body:
                            "Your daily reminder for '${reminder.title}' at ${reminder.interval} has been scheduled. Please refresh your reminder list to see the update.",
                      );

                      Navigator.pop(context, true);
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Failed to set reminder",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
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
