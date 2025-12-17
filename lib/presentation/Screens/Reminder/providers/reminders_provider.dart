import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/prefs_keys.dart';
import 'package:hydra_time/core/models/reminderModel.dart';
import 'package:hydra_time/core/services/shared_prefs_service.dart';

class RemindersProvider extends ChangeNotifier {
  List<ReminderModel> _reminders = [];

  List<ReminderModel> get reminders => _reminders;

  Future<void> loadReminders() async {
    try {
      final prefs = SharedPrefsService.instance;
      final List<String>? rawList = prefs.getStringList(
        PrefsKeys.intervalsReminderList,
      );
      if (rawList != null && rawList.isNotEmpty) {
        _reminders = rawList
            .map((e) => ReminderModel.fromJson(jsonDecode(e)))
            .toList();
      } else {
        _reminders = [];
      }
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error loading reminders: $e");
    }
  }

  Future<void> addReminder(ReminderModel reminder) async {
    try {
      final prefs = SharedPrefsService.instance;
      final List<String> rawList = prefs.getStringList(
        PrefsKeys.intervalsReminderList,
      );
      rawList.add(jsonEncode(reminder.toJson()));
      await prefs.setStringList(PrefsKeys.intervalsReminderList, rawList);
      _reminders.add(reminder);
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error adding reminder: $e");
    }
  }

  Future<void> deleteReminder(ReminderModel reminder) async {
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
      _reminders.removeWhere((r) => r.id == reminder.id);
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error deleting reminder: $e");
    }
  }
}
