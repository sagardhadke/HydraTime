import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/core/constants/app_data.dart';
import 'package:hydra_time/core/models/reminderModel.dart';
import 'package:hydra_time/core/services/logger_service.dart';
import 'package:hydra_time/core/services/notification_service.dart';
import 'package:hydra_time/provider/reminders_provider.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;

class IntervalsRemainder extends StatefulWidget {
  const IntervalsRemainder({super.key});

  @override
  State<IntervalsRemainder> createState() => IntervalsRemainderState();
}

class IntervalsRemainderState extends State<IntervalsRemainder> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController intervalController = TextEditingController();
  final log = LoggerService();

  int? selectedTitleIndex;
  int? selectedDescIndex;
  int? selectedIntervalMinutes;
  bool isLoading = false;

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    intervalController.dispose();
    super.dispose();
  }

  Future<void> _showIntervalPickerDialog() async {
    final List<int> intervals = [15, 20, 30, 40, 45, 60, 90, 120];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.grey60,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select Interval Time",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...intervals.map((minutes) {
                  final isSelected = selectedIntervalMinutes == minutes;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryColor.withOpacity(0.2)
                          : AppColors.grey40,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryColor
                            : AppColors.grey20,
                        width: 1.5,
                      ),
                    ),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          selectedIntervalMinutes = minutes;
                          intervalController.text =
                              "$minutes ${minutes == 1 ? 'Minute' : 'Minutes'}";
                        });
                        Navigator.pop(context);
                      },
                      title: Text(
                        "$minutes ${minutes == 1 ? 'minute' : 'minutes'}",
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.primaryColor
                              : Colors.white,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check_circle,
                              color: AppColors.primaryColor)
                          : null,
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
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
    if (intervalController.text.trim().isEmpty) {
      _showSnackBar("Please select an interval time", isError: true);
      return;
    }

    setState(() => isLoading = true);

    try {
      final int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final reminder = ReminderModel(
        id: id,
        title: titleController.text.trim(),
        description: descController.text.trim(),
        interval: intervalController.text.trim(),
        type: ReminderType.interval,
      );

      // Add to provider
      final provider = context.read<RemindersProvider>();
      final success = await provider.addReminder(reminder);

      if (!success) {
        throw Exception("Failed to save reminder");
      }

      // Schedule notification
      final notificationService = NotificationService();
      final minutes = selectedIntervalMinutes ?? 0;

      if (minutes > 0) {
        final scheduledDate = tz.TZDateTime.now(tz.local).add(
          Duration(minutes: minutes),
        );

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
          title: "Reminder Scheduled ✓",
          body:
              "Your interval reminder has been set for every $minutes minutes.",
        );
      }

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
        title: const Text("Intervals Reminder"),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                _buildSectionTitle("Interval Time"),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: intervalController,
                  hintText: 'Select Interval Time',
                  prefixIcon: CupertinoIcons.clock,
                  readOnly: true,
                  onTap: _showIntervalPickerDialog,
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
        ],
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