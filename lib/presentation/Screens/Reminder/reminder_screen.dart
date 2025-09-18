import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hydra_time/Routes/app_routes.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/core/constants/prefs_keys.dart';
import 'package:hydra_time/core/models/reminderModel.dart';
import 'package:hydra_time/core/services/notification_service.dart';
import 'package:hydra_time/core/services/shared_prefs_service.dart';

class MyReminderScreen extends StatefulWidget {
  const MyReminderScreen({super.key});

  @override
  State<MyReminderScreen> createState() => _MyReminderScreenState();
}

class _MyReminderScreenState extends State<MyReminderScreen> {
  List<ReminderModel> reminders = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    try {
      final prefs = SharedPrefsService.instance;
      final List<String>? rawList = prefs.getStringList(
        PrefsKeys.intervalsReminderList,
      );

      if (rawList == null || rawList.isEmpty) {
        if (mounted) setState(() => reminders = []);
        return;
      }

      final decodedList = rawList
          .map((e) => ReminderModel.fromJson(jsonDecode(e)))
          .toList();

      if (mounted) setState(() => reminders = decodedList);
    } catch (e) {
      debugPrint("❌ Error loading reminders: $e");
    }
  }

  Future<void> _navigateToAddReminder() async {
    final result = await Navigator.pushNamed(context, AppRoutes.setupRemainder);

    if (result == true) {
      _loadReminders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(scrolledUnderElevation: 0, title: const Text("Reminders")),
      body: reminders.isEmpty ? _buildEmptyState() : _buildRemindersList(),
      floatingActionButton: _buildFABs(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/icons/no_notifications.png", height: 200),
          const SizedBox(height: 20),
          const Text("No reminders yet", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _loadReminders,
            child: const Text("Refresh"),
          ),
        ],
      ),
    );
  }

  Widget _buildRemindersList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: reminders.length,
      itemBuilder: (context, index) {
        final reminder = reminders[index];

        return Card(
          color: AppColors.grey60,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text(reminder.title),
            subtitle: Text(reminder.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(reminder.interval),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteReminder(reminder),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteReminder(ReminderModel reminder) async {
    try {
      final prefs = SharedPrefsService.instance;
      final List<String> rawList = prefs.getStringList(
        PrefsKeys.intervalsReminderList,
      );

      final updatedList = rawList.where((item) {
        final decoded = ReminderModel.fromJson(jsonDecode(item));
        return decoded.id != reminder.id;
      }).toList();

      await prefs.setStringList(PrefsKeys.intervalsReminderList, updatedList);

      await NotificationService().cancelNotification(reminder.id);

      _loadReminders();
    } catch (e) {
      debugPrint("❌ Failed to delete reminder: $e");
    }
  }

  Widget _buildFABs() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (reminders.isNotEmpty)
          FloatingActionButton(
            heroTag: "refreshBtn",
            foregroundColor: Colors.white,
            backgroundColor: AppColors.grey40,
            onPressed: _loadReminders,
            child: const Icon(Icons.refresh),
          ),
        const SizedBox(height: 15),
        FloatingActionButton(
          heroTag: "addBtn",
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primaryColor,
          onPressed: _navigateToAddReminder,
          child: const Icon(Icons.add),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
