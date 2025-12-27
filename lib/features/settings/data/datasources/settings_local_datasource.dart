import 'package:hydra_time/core/constants/hive_box_names.dart';
import 'package:hydra_time/core/errors/exceptions.dart';
import 'package:hydra_time/features/settings/data/models/settings_model.dart';
import 'package:hydra_time/services/storage/hive_service.dart';

abstract class SettingsLocalDataSource {
  Future<SettingsModel> getSettings();
  Future<void> saveSettings(SettingsModel settings);
  Future<void> updateSetting(String key, dynamic value);
  Future<void> clearAllSettings();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final HiveService hiveService;

  SettingsLocalDataSourceImpl({required this.hiveService});

  static const String _settingsKey = 'app_settings';

  @override
  Future<SettingsModel> getSettings() async {
    try {
      final box = hiveService.getBox(HiveBoxNames.settings);
      final data = box.get(_settingsKey);

      if (data != null && data is Map) {
        return SettingsModel.fromJson(Map<String, dynamic>.from(data));
      }

      // Return initial settings if none exist
      return SettingsModel.initial();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get settings:  $e',
        code: 'SETTINGS_GET_ERROR',
      );
    }
  }

  @override
  Future<void> saveSettings(SettingsModel settings) async {
    try {
      final box = hiveService.getBox(HiveBoxNames.settings);
      await box.put(_settingsKey, settings.toJson());
    } catch (e) {
      throw CacheException(
        message: 'Failed to save settings: $e',
        code: 'SETTINGS_SAVE_ERROR',
      );
    }
  }

  @override
  Future<void> updateSetting(String key, dynamic value) async {
    try {
      final currentSettings = await getSettings();

      // Create updated settings based on key
      final updated = _updateSettingByKey(currentSettings, key, value);

      await saveSettings(updated);
    } catch (e) {
      throw CacheException(
        message: 'Failed to update setting: $e',
        code: 'SETTINGS_UPDATE_ERROR',
      );
    }
  }

  /// Helper method to update specific setting
  SettingsModel _updateSettingByKey(
    SettingsModel settings,
    String key,
    dynamic value,
  ) {
    switch (key) {
      case 'themeMode':
        return settings.copyWith(themeMode: value as String);
      case 'notificationsEnabled':
        return settings.copyWith(notificationsEnabled: value as bool);
      case 'soundEnabled':
        return settings.copyWith(soundEnabled: value as bool);
      case 'vibrationEnabled':
        return settings.copyWith(vibrationEnabled: value as bool);
      case 'language':
        return settings.copyWith(language: value as String);
      case 'dataBackupEnabled':
        return settings.copyWith(dataBackupEnabled: value as bool);
      case 'lastBackupDate':
        return settings.copyWith(lastBackupDate: value as DateTime?);
      case 'privacyPolicyAccepted':
        return settings.copyWith(privacyPolicyAccepted: value as bool);
      case 'privacyAcceptedDate':
        return settings.copyWith(privacyAcceptedDate: value as DateTime?);
      default:
        return settings;
    }
  }

  @override
  Future<void> clearAllSettings() async {
    try {
      final box = hiveService.getBox(HiveBoxNames.settings);
      await box.delete(_settingsKey);
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear settings: $e',
        code: 'SETTINGS_CLEAR_ERROR',
      );
    }
  }
}
