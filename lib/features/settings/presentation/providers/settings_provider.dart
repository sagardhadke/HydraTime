import 'package:flutter/material.dart';
import 'package:hydra_time/core/usecases/usecase.dart';
import 'package:hydra_time/features/settings/domain/entities/app_settings.dart';
import 'package:hydra_time/features/settings/domain/usecases/clear_all_data.dart';
import 'package:hydra_time/features/settings/domain/usecases/export_data.dart';
import 'package:hydra_time/features/settings/domain/usecases/get_settings.dart';
import 'package:hydra_time/features/settings/domain/usecases/update_theme.dart';

class SettingsProvider extends ChangeNotifier {
  final GetSettings getSettingsUseCase;
  final UpdateTheme updateThemeUseCase;
  final ExportData exportDataUseCase;
  final ClearAllData clearAllDataUseCase;

  SettingsProvider({
    required this.getSettingsUseCase,
    required this.updateThemeUseCase,
    required this.exportDataUseCase,
    required this.clearAllDataUseCase,
  });

  // State variables
  AppSettings?  _settings;
  bool _isLoading = false;
  String? _errorMessage;
  String? _exportedData;

  // Getters
  AppSettings?  get settings => _settings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get exportedData => _exportedData;

  // Derived getters
  bool get notificationsEnabled => _settings?.notificationsEnabled ?? true;
  bool get soundEnabled => _settings?.soundEnabled ?? true;
  bool get vibrationEnabled => _settings?.vibrationEnabled ?? true;
  bool get dataBackupEnabled => _settings?.dataBackupEnabled ?? false;
  String get themeMode => _settings?.themeMode ?? 'dark';
  String get language => _settings?.language ??  'en';

  /// Initialize settings
  Future<void> initializeSettings() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await getSettingsUseCase(NoParams());

      result.fold(
        (failure) {
          _errorMessage = failure.message;
          _isLoading = false;
          notifyListeners();
        },
        (settings) {
          _settings = settings;
          _isLoading = false;
          _errorMessage = null;
          notifyListeners();
        },
      );
    } catch (e) {
      _errorMessage = 'Failed to initialize settings: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update theme
  Future<bool> updateTheme(String themeMode) async {
    try {
      final result = await updateThemeUseCase(
        UpdateThemeParams(themeMode: themeMode),
      );

      final success = result.fold(
        (failure) {
          _errorMessage = failure.message;
          return false;
        },
        (_) {
          _settings = _settings?.copyWith(themeMode: themeMode);
          _errorMessage = null;
          return true;
        },
      );

      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = 'Failed to update theme: $e';
      notifyListeners();
      return false;
    }
  }

  /// Toggle notifications
  Future<bool> toggleNotifications(bool enabled) async {
    try {
      _settings = _settings?.copyWith(notificationsEnabled: enabled);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to toggle notifications: $e';
      notifyListeners();
      return false;
    }
  }

  /// Toggle sound
  Future<bool> toggleSound(bool enabled) async {
    try {
      _settings = _settings?.copyWith(soundEnabled: enabled);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to toggle sound: $e';
      notifyListeners();
      return false;
    }
  }

  /// Toggle vibration
  Future<bool> toggleVibration(bool enabled) async {
    try {
      _settings = _settings?.copyWith(vibrationEnabled: enabled);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to toggle vibration: $e';
      notifyListeners();
      return false;
    }
  }

  /// Toggle data backup
  Future<bool> toggleDataBackup(bool enabled) async {
    try {
      final lastBackupDate = enabled ? DateTime.now() : null;
      _settings = _settings?.copyWith(
        dataBackupEnabled: enabled,
        lastBackupDate: lastBackupDate,
      );
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to toggle data backup: $e';
      notifyListeners();
      return false;
    }
  }

  /// Export data
  Future<bool> exportData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await exportDataUseCase(NoParams());

      return result.fold(
        (failure) {
          _errorMessage = failure.message;
          _isLoading = false;
          notifyListeners();
          return false;
        },
        (data) {
          _exportedData = data;
          _errorMessage = null;
          _isLoading = false;
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      _errorMessage = 'Failed to export data: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear all data
  Future<bool> clearAllData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await clearAllDataUseCase(NoParams());

      return result.fold(
        (failure) {
          _errorMessage = failure.message;
          _isLoading = false;
          notifyListeners();
          return false;
        },
        (_) {
          _settings = null;
          _exportedData = null;
          _errorMessage = null;
          _isLoading = false;
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      _errorMessage = 'Failed to clear data: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Accept privacy policy
  void acceptPrivacyPolicy() {
    _settings = _settings?.copyWith(
      privacyPolicyAccepted: true,
      privacyAcceptedDate:  DateTime.now(),
    );
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}