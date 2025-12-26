import 'package:flutter/material.dart';
import 'package:hydra_time/core/usecases/usecase.dart';
import 'package:hydra_time/features/statistics/domain/entities/achievement.dart';
import 'package:hydra_time/features/statistics/domain/entities/statistics.dart';
import 'package:hydra_time/features/statistics/domain/usecases/get_achievements.dart';
import 'package:hydra_time/features/statistics/domain/usecases/get_daily_statistics.dart';
import 'package:hydra_time/features/statistics/domain/usecases/get_streak.dart';
import 'package:hydra_time/features/statistics/domain/usecases/get_weekly_stats.dart';

enum StatsPeriod { daily, weekly, monthly }

class StatisticsProvider extends ChangeNotifier {
  final GetDailyStatistics getDailyStatisticsUseCase;
  final GetAchievements getAchievementsUseCase;
  final GetStreak getStreakUseCase;
  final GetWeeklyStats getWeeklyStatsUseCase;

  StatisticsProvider({
    required this.getDailyStatisticsUseCase,
    required this.getAchievementsUseCase,
    required this.getStreakUseCase,
    required this.getWeeklyStatsUseCase,
  });

  // State variables
  List<Statistics> _dailyStats = [];
  List<Achievement> _achievements = [];
  List<Achievement> _unlockedAchievements = [];
  double _streak = 0;
  Map<String, double> _weeklyStats = {};
  Map<String, double> _monthlyStats = {};

  StatsPeriod _selectedPeriod = StatsPeriod.daily;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Statistics> get dailyStats => _dailyStats;
  List<Achievement> get achievements => _achievements;
  List<Achievement> get unlockedAchievements => _unlockedAchievements;
  double get streak => _streak;
  Map<String, double> get weeklyStats => _weeklyStats;
  Map<String, double> get monthlyStats => _monthlyStats;
  StatsPeriod get selectedPeriod => _selectedPeriod;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Derived getters
  Statistics? get todayStats =>
      _dailyStats.isNotEmpty ? _dailyStats.first : null;

  double get averageIntake => _dailyStats.isNotEmpty
      ? _dailyStats.fold<double>(0, (sum, stat) => sum + stat.totalIntake) /
            _dailyStats.length
      : 0;

  int get goalsAchieved => _dailyStats.where((s) => s.goalAchieved).length;

  double get achievementPercentage => _achievements.isNotEmpty
      ? (_unlockedAchievements.length / _achievements.length) * 100
      : 0;

  /// Initialize all statistics
  Future<void> initializeStatistics() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Load all data in parallel
      await Future.wait([
        _loadDailyStatistics(),
        _loadAchievements(),
        _loadStreak(),
        _loadWeeklyStats(),
      ]);

      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load statistics:  $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load daily statistics (last 30 days)
  Future<void> _loadDailyStatistics() async {
    try {
      final result = await getDailyStatisticsUseCase(
        const GetDailyStatisticsParams(days: 30),
      );

      result.fold(
        (failure) {
          _errorMessage = failure.message;
        },
        (stats) {
          _dailyStats = stats;
        },
      );
    } catch (e) {
      debugPrint('❌ Error loading daily statistics: $e');
    }
  }

  /// Load achievements
  Future<void> _loadAchievements() async {
    try {
      final result = await getAchievementsUseCase(NoParams());

      result.fold(
        (failure) {
          _errorMessage = failure.message;
        },
        (achievements) {
          _achievements = achievements;
          _unlockedAchievements = achievements
              .where((a) => a.isUnlocked)
              .toList();
        },
      );
    } catch (e) {
      debugPrint('❌ Error loading achievements: $e');
    }
  }

  /// Load streak
  Future<void> _loadStreak() async {
    try {
      final result = await getStreakUseCase(NoParams());

      result.fold(
        (failure) {
          _errorMessage = failure.message;
        },
        (streak) {
          _streak = streak;
        },
      );
    } catch (e) {
      debugPrint('❌ Error loading streak: $e');
    }
  }

  /// Load weekly stats
  Future<void> _loadWeeklyStats() async {
    try {
      final result = await getWeeklyStatsUseCase(NoParams());

      result.fold(
        (failure) {
          _errorMessage = failure.message;
        },
        (stats) {
          _weeklyStats = stats;
        },
      );
    } catch (e) {
      debugPrint('❌ Error loading weekly stats: $e');
    }
  }

  /// Set selected period
  void setPeriod(StatsPeriod period) {
    if (_selectedPeriod != period) {
      _selectedPeriod = period;
      notifyListeners();
    }
  }

  /// Refresh all statistics
  Future<void> refresh() async {
    await initializeStatistics();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
