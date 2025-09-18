import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/core/constants/app_data.dart';
import 'package:hydra_time/core/constants/prefs_keys.dart';
import 'package:hydra_time/core/services/logger_service.dart';
import 'package:hydra_time/core/services/shared_prefs_service.dart';

class IntervalsRemainder extends StatefulWidget {
  const IntervalsRemainder({super.key});

  @override
  State<IntervalsRemainder> createState() => IntervalsRemainderState();
}

class IntervalsRemainderState extends State<IntervalsRemainder> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController intervalController = TextEditingController();
  final log = LoggerService();

  int? selectedTitleIndex;
  int? selectedDescIndex;

  Future<void> showIntervalPickerDialog(BuildContext context) async {
    final List<int> intervals = [20, 30, 40, 50, 60];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text("Select Interval Time"),
          children: intervals.map((minutes) {
            return SimpleDialogOption(
              onPressed: () {
                intervalController.text = "$minutes Minutes";
                Navigator.pop(context);
                // scheduleNotificationAfterInterval(minutes);
              },
              child: Text("$minutes minutes"),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text("Intervals Reminder"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text("Title", style: TextStyle(fontSize: 16)),
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
              const Text("Description", style: TextStyle(fontSize: 16)),
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
              const Text("Interval", style: TextStyle(fontSize: 16)),
              TextField(
                controller: intervalController,
                style: TextStyle(color: AppColors.white),
                readOnly: true,
                onTap: () => showIntervalPickerDialog(context),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.grey40,
                  prefixIcon: Icon(CupertinoIcons.clock),
                  hintText: 'Select Interval Time',
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
                    final prefs = SharedPrefsService.instance;
                    await prefs.setString(
                      PrefsKeys.interval,
                      intervalController.text,
                    );
                    log.d(
                      "Interval Timer Set to be ${intervalController.text}",
                    );

                    Navigator.pop(context);
                    Navigator.pop(context);
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
