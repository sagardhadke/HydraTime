import 'package:flutter/foundation.dart';
import 'package:hydra_time/core/constants/hive_box_names.dart';
import 'package:hydra_time/core/constants/prefs_keys.dart';
import 'package:hydra_time/core/errors/exceptions.dart';
import 'package:hydra_time/core/services/shared_prefs_service.dart';
import 'package:hydra_time/services/storage/hive_service.dart';

class MigrationService {
  static final MigrationService _instance = MigrationService._internal();
  factory MigrationService() => _instance;
  MigrationService._internal();

  final HiveService _hiveService = HiveService();
  final SharedPrefsService _prefsService = SharedPrefsService.instance;

  static const String _migrationKey = 'migration_completed';
  static const String _migrationVersionKey = 'migration_version';
  static const int _currentMigrationVersion = 1;

  Future<bool> needsMigration() async {
    try {
      final migrationBox = _hiveService.getBox(HiveBoxNames.migration);
      final isCompleted = migrationBox.get(_migrationKey, defaultValue: false);
      final version = migrationBox.get(_migrationVersionKey, defaultValue: 0);

      return !isCompleted || version < _currentMigrationVersion;
    } catch (e) {
      debugPrint('❌ Error checking migration status: $e');
      return true;
    }
  }

  Future<void> migrateFromSharedPreferences() async {
    try {
      debugPrint('🔄 Starting migration from SharedPreferences to Hive...');

      if (!await needsMigration()) {
        debugPrint('✅ Migration already completed');
        return;
      }

      await _migrateOnboardingData();
      await _migrateUserProfileData();
      await _migrateWaterTrackingData();
      await _migrateRemindersData();
      await _migrateSettingsData();

      await _markMigrationComplete();

      debugPrint('✅ Migration completed successfully');
    } catch (e) {
      debugPrint('❌ Migration failed: $e');
      throw MigrationException(
        message: 'Failed to migrate data: $e',
        code: 'MIGRATION_ERROR',
      );
    }
  }

  Future<void> _migrateOnboardingData() async {
    try {
      final onboardingBox = _hiveService.getBox(HiveBoxNames.onboarding);

      final isComplete = _prefsService.getBool(PrefsKeys.onboardingComplete);

      await onboardingBox.put('is_completed', isComplete);

      debugPrint('✅ Onboarding data migrated');
    } catch (e) {
      debugPrint('❌ Failed to migrate onboarding data: $e');
    }
  }

  Future<void> _migrateUserProfileData() async {
    try {
      final profileBox = _hiveService.getBox(HiveBoxNames.userProfile);

      final profileData = {
        'full_name': _prefsService.getString(PrefsKeys.fullName),
        'dob': _prefsService.getString(PrefsKeys.dob),
        'gender': _prefsService.getString(PrefsKeys.gender),
        'height': _prefsService.getString(PrefsKeys.height),
        'weight': _prefsService.getString(PrefsKeys.weight),
        'wake_up_time': _prefsService.getString(PrefsKeys.wakeUpTime),
        'bed_time': _prefsService.getString(PrefsKeys.bedTime),
        'activity': _prefsService.getString(PrefsKeys.activity),
        'climate': _prefsService.getString(PrefsKeys.climate),
        'daily_target': _prefsService.getDouble(PrefsKeys.dailyTarget),
      };

      await profileBox.put('user_profile', profileData);

      debugPrint('✅ User profile data migrated');
    } catch (e) {
      debugPrint('❌ Failed to migrate user profile: $e');
    }
  }

  Future<void> _migrateWaterTrackingData() async {
    try {
      final waterBox = _hiveService.getBox(HiveBoxNames.waterIntake);

      final currentWater = _prefsService.getDouble(PrefsKeys.currentWater);
      final selectedWater = _prefsService.getDouble(PrefsKeys.selectedWater);
      final lastResetDate = _prefsService.getString(PrefsKeys.lastResetDate);

      await waterBox.put('current_water', currentWater);
      await waterBox.put('selected_water', selectedWater);
      await waterBox.put('last_reset_date', lastResetDate);

      debugPrint('✅ Water tracking data migrated');
    } catch (e) {
      debugPrint('❌ Failed to migrate water tracking data: $e');
    }
  }

  Future<void> _migrateRemindersData() async {
    try {
      final remindersBox = _hiveService.getBox(HiveBoxNames.reminders);

      final remindersList = _prefsService.getStringList(
        PrefsKeys.intervalsReminderList,
      );

      await remindersBox.put('reminders_list', remindersList);

      debugPrint('✅ Reminders data migrated (${remindersList.length} items)');
    } catch (e) {
      debugPrint('❌ Failed to migrate reminders: $e');
    }
  }

  Future<void> _migrateSettingsData() async {
    try {
      final settingsBox = _hiveService.getBox(HiveBoxNames.settings);

      final settingsData = {
        'theme_mode': 'dark',
        'notifications_enabled': true,
      };

      await settingsBox.put('app_settings', settingsData);

      debugPrint('✅ Settings data migrated');
    } catch (e) {
      debugPrint('❌ Failed to migrate settings: $e');
    }
  }

  Future<void> _markMigrationComplete() async {
    try {
      final migrationBox = _hiveService.getBox(HiveBoxNames.migration);
      await migrationBox.put(_migrationKey, true);
      await migrationBox.put(_migrationVersionKey, _currentMigrationVersion);
      await migrationBox.put(
        'migration_date',
        DateTime.now().toIso8601String(),
      );

      debugPrint('✅ Migration marked as complete');
    } catch (e) {
      debugPrint('❌ Failed to mark migration complete: $e');
    }
  }

  Future<void> rollbackMigration() async {
    try {
      debugPrint('⚠️ Rolling back migration...');

      final migrationBox = _hiveService.getBox(HiveBoxNames.migration);
      await migrationBox.clear();

      debugPrint('✅ Migration rolled back');
    } catch (e) {
      debugPrint('❌ Failed to rollback migration: $e');
    }
  }

  Future<Map<String, dynamic>> getMigrationStatus() async {
    try {
      final migrationBox = _hiveService.getBox(HiveBoxNames.migration);

      return {
        'completed': migrationBox.get(_migrationKey, defaultValue: false),
        'version': migrationBox.get(_migrationVersionKey, defaultValue: 0),
        'date': migrationBox.get('migration_date', defaultValue: 'N/A'),
      };
    } catch (e) {
      return {'completed': false, 'version': 0, 'date': 'Error'};
    }
  }
}
