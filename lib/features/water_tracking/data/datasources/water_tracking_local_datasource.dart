import 'package:hydra_time/core/constants/hive_box_names.dart';
import 'package:hydra_time/core/errors/exceptions.dart';
import 'package:hydra_time/features/water_tracking/data/models/daily_log_model.dart';
import 'package:hydra_time/features/water_tracking/data/models/water_intake_model.dart';
import 'package:hydra_time/services/storage/hive_service.dart';

abstract class WaterTrackingLocalDataSource {
  Future<DailyLogModel> getDailyLog(DateTime date);
  Future<void> addWaterIntake(WaterIntakeModel intake);
  Future<void> removeWaterIntake(String intakeId);
  Future<void> resetDailyLog(DateTime date);
  Future<List<DailyLogModel>> getLogHistory(int days);
}

class WaterTrackingLocalDataSourceImpl implements WaterTrackingLocalDataSource {
  final HiveService hiveService;

  WaterTrackingLocalDataSourceImpl({required this.hiveService});

  String _getLogKey(DateTime date) {
    return 'log_${date.year}_${date.month}_${date.day}';
  }

  @override
  Future<DailyLogModel> getDailyLog(DateTime date) async {
    try {
      final box = hiveService.getBox(HiveBoxNames.dailyLogs);
      final key = _getLogKey(date);
      final data = box.get(key);

      if (data == null) {
        // Return empty log with default goal (2000ml)
        return DailyLogModel.initial(dailyGoal: 2000);
      }

      if (data is Map) {
        return DailyLogModel.fromJson(Map<String, dynamic>.from(data));
      }

      return DailyLogModel.initial(dailyGoal: 2000);
    } catch (e) {
      throw CacheException(
        message: 'Failed to get daily log:  $e',
        code: 'LOG_GET_ERROR',
      );
    }
  }

  @override
  Future<void> addWaterIntake(WaterIntakeModel intake) async {
    try {
      final box = hiveService.getBox(HiveBoxNames.dailyLogs);
      final logDate = DateTime(
        intake.timestamp.year,
        intake.timestamp.month,
        intake.timestamp.day,
      );
      final key = _getLogKey(logDate);

      final currentLog = await getDailyLog(logDate);
      final updatedIntakes = [...currentLog.intakes, intake];
      final totalIntake = updatedIntakes.fold<double>(
        0,
        (sum, intake) => sum + intake.amount,
      );

      final updatedLog = currentLog.copyWith(
        intakes: updatedIntakes,
        totalIntake: totalIntake,
      );

      await box.put(key, updatedLog.toJson());
    } catch (e) {
      throw CacheException(
        message: 'Failed to add water intake: $e',
        code: 'INTAKE_ADD_ERROR',
      );
    }
  }

  @override
  Future<void> removeWaterIntake(String intakeId) async {
    try {
      final box = hiveService.getBox(HiveBoxNames.dailyLogs);
      final now = DateTime.now();
      final key = _getLogKey(now);

      final currentLog = await getDailyLog(now);
      final updatedIntakes = currentLog.intakes
          .where((intake) => intake.id != intakeId)
          .toList();
      final totalIntake = updatedIntakes.fold<double>(
        0,
        (sum, intake) => sum + intake.amount,
      );

      final updatedLog = currentLog.copyWith(
        intakes: updatedIntakes,
        totalIntake: totalIntake,
      );

      await box.put(key, updatedLog.toJson());
    } catch (e) {
      throw CacheException(
        message: 'Failed to remove water intake: $e',
        code: 'INTAKE_REMOVE_ERROR',
      );
    }
  }

  @override
  Future<void> resetDailyLog(DateTime date) async {
    try {
      final box = hiveService.getBox(HiveBoxNames.dailyLogs);
      final key = _getLogKey(date);
      await box.delete(key);
    } catch (e) {
      throw CacheException(
        message: 'Failed to reset daily log: $e',
        code: 'LOG_RESET_ERROR',
      );
    }
  }

  @override
  Future<List<DailyLogModel>> getLogHistory(int days) async {
    try {
      final box = hiveService.getBox(HiveBoxNames.dailyLogs);
      final logs = <DailyLogModel>[];

      for (int i = 0; i < days; i++) {
        final date = DateTime.now().subtract(Duration(days: i));
        final key = _getLogKey(date);
        final data = box.get(key);

        if (data != null && data is Map) {
          logs.add(DailyLogModel.fromJson(Map<String, dynamic>.from(data)));
        }
      }

      return logs;
    } catch (e) {
      throw CacheException(
        message: 'Failed to get log history: $e',
        code: 'HISTORY_GET_ERROR',
      );
    }
  }
}
