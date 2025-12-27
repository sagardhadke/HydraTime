import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydra_time/core/constants/hive_box_names.dart';
import 'package:hydra_time/core/errors/exceptions.dart';
import 'package:hydra_time/core/theme/models/theme_settings_model.dart';
import 'package:hydra_time/features/onboarding/data/models/onboarding_model.dart';
import 'package:hydra_time/features/settings/data/models/settings_model.dart';
import 'package:hydra_time/features/user_profile/data/models/user_profile_model.dart';
import 'package:hydra_time/features/water_tracking/data/models/daily_log_model.dart';
import 'package:hydra_time/features/water_tracking/data/models/water_intake_model.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      await Hive.initFlutter();

      if (!kIsWeb) {
        final appDocumentDir = await getApplicationDocumentsDirectory();
        Hive.init(appDocumentDir.path);
      }

      debugPrint('✅ Hive initialized successfully');
      _isInitialized = true;
    } catch (e) {
      debugPrint('❌ Hive initialization failed: $e');
      throw StorageException(
        message: 'Failed to initialize Hive: $e',
        code: 'HIVE_INIT_ERROR',
      );
    }
  }

  Future<void> registerAdapters() async {
    try {
      if (!Hive.isAdapterRegistered(7)) {
        Hive.registerAdapter(ThemeSettingsModelAdapter());
      }
      if (!Hive.isAdapterRegistered(8)) {
        Hive.registerAdapter(OnboardingModelAdapter());
      }
      if (!Hive.isAdapterRegistered(9)) {
        Hive.registerAdapter(SettingsModelAdapter());
      }
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(UserProfileModelAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(WaterIntakeModelAdapter());
      }
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(DailyLogModelAdapter());
      }

      debugPrint('✅ Hive adapters registered successfully');
    } catch (e) {
      debugPrint('❌ Adapter registration failed: $e');
      throw StorageException(
        message: 'Failed to register adapters: $e',
        code: 'ADAPTER_REG_ERROR',
      );
    }
  }

  Future<void> openBoxes() async {
    try {
      await Future.wait([
        _openBox(HiveBoxNames.userProfile),
        _openBox(HiveBoxNames.waterIntake),
        _openBox(HiveBoxNames.dailyLogs),
        _openBox(HiveBoxNames.reminders),
        _openBox(HiveBoxNames.statistics),
        _openBox(HiveBoxNames.achievements),
        _openBox(HiveBoxNames.settings),
        _openBox(HiveBoxNames.onboarding),
        _openBox(HiveBoxNames.migration),
      ]);

      debugPrint('✅ All Hive boxes opened successfully');
    } catch (e) {
      debugPrint('❌ Failed to open boxes: $e');
      throw StorageException(
        message: 'Failed to open boxes: $e',
        code: 'BOX_OPEN_ERROR',
      );
    }
  }

  Future<Box> _openBox(String boxName) async {
    try {
      if (Hive.isBoxOpen(boxName)) {
        return Hive.box(boxName);
      }
      return await Hive.openBox(boxName);
    } catch (e) {
      throw StorageException(
        message: 'Failed to open box $boxName: $e',
        code: 'BOX_OPEN_ERROR',
      );
    }
  }

  Box<T> getBox<T>(String boxName) {
    try {
      if (!Hive.isBoxOpen(boxName)) {
        throw StorageException(
          message: 'Box $boxName is not open',
          code: 'BOX_NOT_OPEN',
        );
      }
      return Hive.box<T>(boxName);
    } catch (e) {
      throw StorageException(
        message: 'Failed to get box $boxName: $e',
        code: 'BOX_GET_ERROR',
      );
    }
  }

  Future<void> closeBox(String boxName) async {
    try {
      if (Hive.isBoxOpen(boxName)) {
        await Hive.box(boxName).close();
        debugPrint('✅ Box $boxName closed');
      }
    } catch (e) {
      debugPrint('❌ Failed to close box $boxName: $e');
    }
  }

  Future<void> closeAllBoxes() async {
    try {
      await Hive.close();
      debugPrint('✅ All Hive boxes closed');
    } catch (e) {
      debugPrint('❌ Failed to close boxes: $e');
    }
  }

  Future<void> deleteBox(String boxName) async {
    try {
      await Hive.deleteBoxFromDisk(boxName);
      debugPrint('✅ Box $boxName deleted');
    } catch (e) {
      debugPrint('❌ Failed to delete box $boxName: $e');
      throw StorageException(
        message: 'Failed to delete box $boxName: $e',
        code: 'BOX_DELETE_ERROR',
      );
    }
  }

  Future<void> clearAllData() async {
    try {
      final boxes = [
        HiveBoxNames.userProfile,
        HiveBoxNames.waterIntake,
        HiveBoxNames.dailyLogs,
        HiveBoxNames.reminders,
        HiveBoxNames.statistics,
        HiveBoxNames.achievements,
        HiveBoxNames.settings,
      ];

      for (final boxName in boxes) {
        if (Hive.isBoxOpen(boxName)) {
          await Hive.box(boxName).clear();
        }
      }

      debugPrint('✅ All data cleared from boxes');
    } catch (e) {
      debugPrint('❌ Failed to clear data: $e');
      throw StorageException(
        message: 'Failed to clear data: $e',
        code: 'CLEAR_DATA_ERROR',
      );
    }
  }

  Future<void> compactAllBoxes() async {
    try {
      final boxes = Hive.box(HiveBoxNames.userProfile);
      await boxes.compact();

      debugPrint('✅ Boxes compacted');
    } catch (e) {
      debugPrint('❌ Failed to compact boxes: $e');
    }
  }

  bool boxExists(String boxName) {
    return Hive.isBoxOpen(boxName);
  }

  int getBoxSize(String boxName) {
    try {
      if (Hive.isBoxOpen(boxName)) {
        return Hive.box(boxName).length;
      }
      return 0;
    } catch (e) {
      debugPrint('❌ Failed to get box size: $e');
      return 0;
    }
  }
}
