import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/prefs_keys.dart';
import 'package:hydra_time/core/models/reminderModel.dart';
import 'package:hydra_time/core/services/notification_service.dart';
import 'package:hydra_time/core/services/shared_prefs_service.dart';

enum ReminderFilter { all, intervals, specificTime }

class RemindersProvider extends ChangeNotifier {
  List<ReminderModel> _allReminders = [];
  List<ReminderModel> _filteredReminders = [];
  ReminderFilter _currentFilter = ReminderFilter.all;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<ReminderModel> get reminders => _filteredReminders;
  ReminderFilter get currentFilter => _currentFilter;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasReminders => _filteredReminders.isNotEmpty;
  int get totalReminders => _allReminders.length;
  int get intervalRemindersCount =>
      _allReminders.where((r) => r.type == ReminderType.interval).length;
  int get specificRemindersCount =>
      _allReminders.where((r) => r.type == ReminderType.specificTime).length;

  // Initialize and load reminders
  Future<void> loadReminders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = SharedPrefsService.instance;
      final List<String> rawList = prefs.getStringList(
        PrefsKeys.intervalsReminderList,
      );

      if (rawList.isEmpty) {
        _allReminders = [];
        _filteredReminders = [];
      } else {
        _allReminders =
            rawList.map((e) => ReminderModel.fromJson(jsonDecode(e))).toList()
              ..sort((a, b) => b.id.compareTo(a.id)); // Sort by newest first

        _applyFilter();
      }
    } catch (e) {
      _errorMessage = "Failed to load reminders: $e";
      debugPrint("❌ Error loading reminders: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add new reminder
  Future<bool> addReminder(ReminderModel reminder) async {
    try {
      final prefs = SharedPrefsService.instance;
      final existingList = prefs.getStringList(PrefsKeys.intervalsReminderList);
      final modifiableList = [...existingList, jsonEncode(reminder.toJson())];

      final success = await prefs.setStringList(
        PrefsKeys.intervalsReminderList,
        modifiableList,
      );

      if (success) {
        _allReminders.insert(0, reminder); // Add to beginning
        _applyFilter();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = "Failed to add reminder: $e";
      debugPrint("❌ Error adding reminder: $e");
      notifyListeners();
      return false;
    }
  }

  // Delete reminder
  Future<bool> deleteReminder(ReminderModel reminder) async {
    try {
      final prefs = SharedPrefsService.instance;
      final List<String> rawList = prefs.getStringList(
        PrefsKeys.intervalsReminderList,
      );

      final updatedList = rawList.where((item) {
        final decoded = ReminderModel.fromJson(jsonDecode(item));
        return decoded.id != reminder.id;
      }).toList();

      final success = await prefs.setStringList(
        PrefsKeys.intervalsReminderList,
        updatedList,
      );

      if (success) {
        // Cancel notification
        await NotificationService().cancelNotification(reminder.id);

        // Update local state
        _allReminders.removeWhere((r) => r.id == reminder.id);
        _applyFilter();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = "Failed to delete reminder: $e";
      debugPrint("❌ Error deleting reminder: $e");
      notifyListeners();
      return false;
    }
  }

  // Update filter
  void setFilter(ReminderFilter filter) {
    if (_currentFilter != filter) {
      _currentFilter = filter;
      _applyFilter();
      notifyListeners();
    }
  }

  // Apply current filter
  void _applyFilter() {
    switch (_currentFilter) {
      case ReminderFilter.all:
        _filteredReminders = List.from(_allReminders);
        break;
      case ReminderFilter.intervals:
        _filteredReminders = _allReminders
            .where((r) => r.type == ReminderType.interval)
            .toList();
        break;
      case ReminderFilter.specificTime:
        _filteredReminders = _allReminders
            .where((r) => r.type == ReminderType.specificTime)
            .toList();
        break;
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Delete all reminders
  Future<bool> deleteAllReminders() async {
    try {
      final prefs = SharedPrefsService.instance;
      final success = await prefs.setStringList(
        PrefsKeys.intervalsReminderList,
        [],
      );

      if (success) {
        // Cancel all notifications
        await NotificationService().cancelAllNotifications();

        _allReminders.clear();
        _filteredReminders.clear();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = "Failed to delete all reminders: $e";
      debugPrint("❌ Error deleting all reminders: $e");
      notifyListeners();
      return false;
    }
  }
}
