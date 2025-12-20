import 'dart:convert';
import 'dart:io';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/core/constants/app_data.dart';
import 'package:hydra_time/core/models/reminderModel.dart';
import 'package:hydra_time/core/services/logger_service.dart';
import 'package:hydra_time/core/services/notification_service.dart';
import 'package:hydra_time/provider/reminders_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;

class SpecificRemainder extends StatefulWidget {
  const SpecificRemainder({super.key});

  @override
  State<SpecificRemainder> createState() => SpecificRemainderState();
}

class SpecificRemainderState extends State<SpecificRemainder> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController specificTimeController = TextEditingController();

  DateTime nowTime = DateTime.now();
  final log = LoggerService();

  int? selectedTitleIndex;
  int? selectedDescIndex;
  bool isIos = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isIos = Platform.isIOS;
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    specificTimeController.dispose();
    super.dispose();
  }

  void _showTimePicker({
    required TimeOfDay initialTime,
    required Function(TimeOfDay) onConfirm,
  }) {
    Navigator.of(context).push(
      showPicker(
        context: context,
        accentColor: AppColors.primaryColor,
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

  String _formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  Future<void> _saveReminder() async {
    // Validation
    if (titleController.text.trim().isEmpty) {
      _showSnackBar("Please enter a title", isError: true);
      return;
    }
    if (descController.text.trim().isEmpty) {
      _showSnackBar("Please enter a description", isError: true);
      return;
    }
    if (specificTimeController.text.trim().isEmpty) {
      _showSnackBar("Please select a time", isError: true);
      return;
    }

    setState(() => isLoading = true);

    try {
      final int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final reminder = ReminderModel(
        id: id,
        title: titleController.text.trim(),
        description: descController.text.trim(),
        interval: specificTimeController.text.trim(),
        type: ReminderType.specificTime,
      );

      // Add to provider
      final provider = context.read<RemindersProvider>();
      final success = await provider.addReminder(reminder);

      if (!success) {
        throw Exception("Failed to save reminder");
      }

      // Schedule notification
      final now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        nowTime.hour,
        nowTime.minute,
      );

      // If time has passed today, schedule for tomorrow
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      final notificationService = NotificationService();
      await notificationService.scheduleReminder(
        id: id,
        title: reminder.title,
        body: reminder.description,
        scheduledDate: scheduledDate,
        payload: jsonEncode(reminder.toJson()),
      );

      // Show success notification
      await notificationService.instantNotification(
        id: id + 1,
        title: "Reminder Set Successfully ✓",
        body:
            "Your daily reminder for '${reminder.title}' at ${reminder.interval} has been scheduled.",
      );

      if (mounted) {
        Navigator.pop(context, true);
        Navigator.pop(context);
      }
    } catch (e) {
      log.e("Failed to save reminder: $e");
      _showSnackBar("Failed to save reminder", isError: true);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text("Specific Time Reminder"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Title"),
            const SizedBox(height: 8),
            _buildTextField(
              controller: titleController,
              hintText: 'Write your title here',
              prefixIcon: Icons.title,
            ),
            const SizedBox(height: 12),
            _buildTitleChips(),
            const SizedBox(height: 20),
            _buildSectionTitle("Description"),
            const SizedBox(height: 8),
            _buildTextField(
              controller: descController,
              hintText: 'Write your description here',
              prefixIcon: Icons.description,
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            _buildDescChips(),
            const SizedBox(height: 20),
            _buildSectionTitle("Time"),
            const SizedBox(height: 8),
            _buildTextField(
              controller: specificTimeController,
              hintText: 'Select Time',
              prefixIcon: Icons.wb_twilight,
              readOnly: true,
              onTap: () => _showTimePicker(
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
                    specificTimeController.text = _formatTimeOfDay(value);
                  });
                },
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _saveReminder,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : const Text(
                        "Save Reminder",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool readOnly = false,
    int maxLines = 1,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: AppColors.white),
      readOnly: readOnly,
      maxLines: maxLines,
      onTap: onTap,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.grey40,
        prefixIcon: Icon(prefixIcon, color: AppColors.primaryColor),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey20, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey20, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
      ),
    );
  }

  Widget _buildTitleChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(AppData.reminderTitle.length, (index) {
        final item = AppData.reminderTitle[index];
        final isSelected = selectedTitleIndex == index;
        return ChoiceChip(
          label: Text(item),
          selected: isSelected,
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
            color: isSelected ? Colors.black : Colors.grey[300],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
          side: BorderSide(
            color: isSelected ? AppColors.primaryColor : AppColors.grey20,
            width: 1,
          ),
        );
      }),
    );
  }

  Widget _buildDescChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(AppData.reminderDesc.length, (index) {
        final item = AppData.reminderDesc[index];
        final isSelected = selectedDescIndex == index;
        return ChoiceChip(
          label: Text(item),
          selected: isSelected,
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
            color: isSelected ? Colors.black : Colors.grey[300],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
          side: BorderSide(
            color: isSelected ? AppColors.primaryColor : AppColors.grey20,
            width: 1,
          ),
        );
      }),
    );
  }
}