import 'package:hydra_time/core/constants/hive_box_names.dart';
import 'package:hydra_time/core/errors/exceptions.dart';
import 'package:hydra_time/features/statistics/data/models/achievement_model.dart';
import 'package:hydra_time/features/statistics/data/models/statistics_model.dart';
import 'package:hydra_time/services/storage/hive_service.dart';

abstract class StatisticsLocalDataSource {
  Future<List<StatisticsModel>> getStatistics(int days);
  Future<StatisticsModel?> getStatisticsByDate(DateTime date);
  Future<void> saveStatistics(StatisticsModel stat);
  Future<void> saveAchievement(AchievementModel achievement);
  Future<List<AchievementModel>> getAchievements();
  Future<List<AchievementModel>> getUnlockedAchievements();
}

class StatisticsLocalDataSourceImpl implements StatisticsLocalDataSource {
  final HiveService hiveService;

  StatisticsLocalDataSourceImpl({required this.hiveService});

  String _getStatsKey(DateTime date) {
    return 'stats_${date.year}_${date.month}_${date.day}';
  }

  @override
  Future<List<StatisticsModel>> getStatistics(int days) async {
    try {
      final box = hiveService.getBox(HiveBoxNames.statistics);
      final stats = <StatisticsModel>[];

      for (int i = 0; i < days; i++) {
        final date = DateTime.now().subtract(Duration(days: i));
        final key = _getStatsKey(date);
        final data = box.get(key);

        if (data != null && data is Map) {
          stats.add(StatisticsModel.fromJson(Map<String, dynamic>.from(data)));
        }
      }

      return stats;
    } catch (e) {
      throw CacheException(
        message: 'Failed to get statistics:  $e',
        code: 'STATS_GET_ERROR',
      );
    }
  }

  @override
  Future<StatisticsModel?> getStatisticsByDate(DateTime date) async {
    try {
      final box = hiveService.getBox(HiveBoxNames.statistics);
      final key = _getStatsKey(date);
      final data = box.get(key);

      if (data != null && data is Map) {
        return StatisticsModel.fromJson(Map<String, dynamic>.from(data));
      }

      return null;
    } catch (e) {
      throw CacheException(
        message: 'Failed to get statistics for date: $e',
        code: 'STATS_DATE_ERROR',
      );
    }
  }

  @override
  Future<void> saveStatistics(StatisticsModel stat) async {
    try {
      final box = hiveService.getBox(HiveBoxNames.statistics);
      final key = _getStatsKey(stat.date);
      await box.put(key, stat.toJson());
    } catch (e) {
      throw CacheException(
        message: 'Failed to save statistics: $e',
        code: 'STATS_SAVE_ERROR',
      );
    }
  }

  @override
  Future<void> saveAchievement(AchievementModel achievement) async {
    try {
      final box = hiveService.getBox(HiveBoxNames.achievements);
      await box.put(achievement.id, achievement.toJson());
    } catch (e) {
      throw CacheException(
        message: 'Failed to save achievement:  $e',
        code: 'ACHIEVEMENT_SAVE_ERROR',
      );
    }
  }

  @override
  Future<List<AchievementModel>> getAchievements() async {
    try {
      final box = hiveService.getBox(HiveBoxNames.achievements);
      final achievements = <AchievementModel>[];

      for (var key in box.keys) {
        final data = box.get(key);
        if (data != null && data is Map) {
          achievements.add(
            AchievementModel.fromJson(Map<String, dynamic>.from(data)),
          );
        }
      }

      return achievements;
    } catch (e) {
      throw CacheException(
        message: 'Failed to get achievements: $e',
        code: 'ACHIEVEMENTS_GET_ERROR',
      );
    }
  }

  @override
  Future<List<AchievementModel>> getUnlockedAchievements() async {
    try {
      final allAchievements = await getAchievements();
      return allAchievements.where((a) => a.isUnlocked).toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get unlocked achievements:  $e',
        code: 'UNLOCKED_ACHIEVEMENTS_ERROR',
      );
    }
  }
}
