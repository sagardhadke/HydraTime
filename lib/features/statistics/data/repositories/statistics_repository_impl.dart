import 'package:dartz/dartz.dart';
import 'package:hydra_time/core/errors/exceptions.dart';
import 'package:hydra_time/core/errors/failures.dart';
import 'package:hydra_time/features/statistics/data/datasources/statistics_local_datasource.dart';
import 'package:hydra_time/features/statistics/data/models/achievement_model.dart';
import 'package:hydra_time/features/statistics/data/models/statistics_model.dart';
import 'package:hydra_time/features/statistics/domain/entities/achievement.dart';
import 'package:hydra_time/features/statistics/domain/entities/statistics.dart';
import 'package:hydra_time/features/statistics/domain/repositories/statistics_repository.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final StatisticsLocalDataSource localDataSource;

  StatisticsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Statistics>>> getDailyStatistics(int days) async {
    try {
      final stats = await localDataSource.getStatistics(days);
      return Right(stats);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Statistics?>> getStatisticsByDate(
    DateTime date,
  ) async {
    try {
      final stat = await localDataSource.getStatisticsByDate(date);
      return Right(stat);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveStatistics(Statistics stat) async {
    try {
      // Convert to model
      final statModel = StatisticsModel.fromEntity(stat);
      await localDataSource.saveStatistics(statModel);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error:  $e'));
    }
  }

  @override
  Future<Either<Failure, List<Achievement>>> getAchievements() async {
    try {
      final achievements = await localDataSource.getAchievements();
      return Right(achievements);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Achievement>>> getUnlockedAchievements() async {
    try {
      final achievements = await localDataSource.getUnlockedAchievements();
      return Right(achievements);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveAchievement(Achievement achievement) async {
    try {
      final model = AchievementModel.fromEntity(achievement);
      await localDataSource.saveAchievement(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, double>> calculateStreak() async {
    try {
      final stats = await localDataSource.getStatistics(365);
      int streak = 0;

      for (final stat in stats) {
        if (stat.goalAchieved) {
          streak++;
        } else {
          break;
        }
      }

      return Right(streak.toDouble());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, double>>> getWeeklyStats() async {
    try {
      final stats = await localDataSource.getStatistics(7);
      final weeklyStats = <String, double>{};

      for (int i = 0; i < 7; i++) {
        final date = DateTime.now().subtract(Duration(days: i));
        final weekDay = [
          'Mon',
          'Tue',
          'Wed',
          'Thu',
          'Fri',
          'Sat',
          'Sun',
        ][date.weekday == 7 ? 6 : date.weekday - 1];

        // Find matching stat or create empty one
        final stat = stats.isNotEmpty
            ? stats.firstWhere(
                (s) =>
                    s.date.year == date.year &&
                    s.date.month == date.month &&
                    s.date.day == date.day,
                orElse: () => StatisticsModel(
                  date: date,
                  totalIntake: 0,
                  dailyGoal: 2000,
                  percentage: 0,
                  goalAchieved: false,
                  intakesCount: 0,
                ),
              )
            : StatisticsModel(
                date: date,
                totalIntake: 0,
                dailyGoal: 2000,
                percentage: 0,
                goalAchieved: false,
                intakesCount: 0,
              );

        weeklyStats[weekDay] = stat.totalIntake;
      }

      return Right(weeklyStats);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, double>>> getMonthlyStats() async {
    try {
      final stats = await localDataSource.getStatistics(30);
      final monthlyStats = <String, double>{};

      for (int i = 0; i < 30; i++) {
        final date = DateTime.now().subtract(Duration(days: i));
        final dayKey = 'Day ${date.day}';

        // Find matching stat or create empty one
        final stat = stats.isNotEmpty
            ? stats.firstWhere(
                (s) =>
                    s.date.year == date.year &&
                    s.date.month == date.month &&
                    s.date.day == date.day,
                orElse: () => StatisticsModel(
                  date: date,
                  totalIntake: 0,
                  dailyGoal: 2000,
                  percentage: 0,
                  goalAchieved: false,
                  intakesCount: 0,
                ),
              )
            : StatisticsModel(
                date: date,
                totalIntake: 0,
                dailyGoal: 2000,
                percentage: 0,
                goalAchieved: false,
                intakesCount: 0,
              );

        monthlyStats[dayKey] = stat.percentage;
      }

      return Right(monthlyStats);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }
}
