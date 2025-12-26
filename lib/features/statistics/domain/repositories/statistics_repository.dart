import 'package:dartz/dartz.dart';
import 'package:hydra_time/core/errors/failures.dart';
import 'package:hydra_time/features/statistics/domain/entities/achievement.dart';
import 'package:hydra_time/features/statistics/domain/entities/statistics.dart';

abstract class StatisticsRepository {
  Future<Either<Failure, List<Statistics>>> getDailyStatistics(int days);
  Future<Either<Failure, Statistics?>> getStatisticsByDate(DateTime date);
  Future<Either<Failure, void>> saveStatistics(Statistics stat);
  Future<Either<Failure, List<Achievement>>> getAchievements();
  Future<Either<Failure, List<Achievement>>> getUnlockedAchievements();
  Future<Either<Failure, void>> saveAchievement(Achievement achievement);
  Future<Either<Failure, double>> calculateStreak();
  Future<Either<Failure, Map<String, double>>> getWeeklyStats();
  Future<Either<Failure, Map<String, double>>> getMonthlyStats();
}
