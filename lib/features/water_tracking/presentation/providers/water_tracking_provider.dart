import 'package:flutter/material.dart';
import 'package:hydra_time/features/user_profile/domain/entities/user_profile.dart';
import 'package:hydra_time/features/water_tracking/domain/entities/daily_log.dart';
import 'package:hydra_time/features/water_tracking/domain/entities/water_intake.dart';
import 'package:hydra_time/features/water_tracking/domain/usecases/add_water_intake.dart';
import 'package:hydra_time/features/water_tracking/domain/usecases/get_daily_intake.dart';
import 'package:hydra_time/features/water_tracking/domain/usecases/get_intake_history.dart';
import 'package:hydra_time/features/water_tracking/domain/usecases/remove_water_intake.dart';

class WaterTrackingProvider extends ChangeNotifier {
  final GetDailyIntake getDailyIntakeUseCase;
  final AddWaterIntake addWaterIntakeUseCase;
  final RemoveWaterIntake removeWaterIntakeUseCase;
  final GetIntakeHistory getIntakeHistoryUseCase;

  WaterTrackingProvider({
    required this.getDailyIntakeUseCase,
    required this.addWaterIntakeUseCase,
    required this.removeWaterIntakeUseCase,
    required this.getIntakeHistoryUseCase,
  });

  // State variables
  DailyLog? _dailyLog;
  List<DailyLog> _logHistory = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _goalAchieved = false;

  // Getters
  DailyLog? get dailyLog => _dailyLog;
  List<DailyLog> get logHistory => _logHistory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get goalAchieved => _goalAchieved;

  double get totalIntake => _dailyLog?.totalIntake ?? 0;
  double get dailyGoal => _dailyLog?.dailyGoal ?? 2000;
  double get percentage => _dailyLog?.percentage ?? 0;
  int get remainingMl => _dailyLog?.remainingMl ?? 0;
  List<WaterIntake> get intakes => _dailyLog?.intakes ?? [];

  /// Initialize water tracking for today
  Future<void> initializeTodayTracking(UserProfile? userProfile) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Get user's daily goal
      final goal = userProfile?.dailyWaterGoal ?? 2000;

      // Load today's log
      final result = await getDailyIntakeUseCase(
        GetDailyIntakeParams(date: DateTime.now()),
      );

      result.fold(
        (failure) {
          _errorMessage = failure.message;
          _isLoading = false;
          notifyListeners();
        },
        (log) {
          // Update goal if different
          if (log.dailyGoal != goal) {
            _dailyLog = log.copyWith(dailyGoal: goal);
          } else {
            _dailyLog = log;
          }

          _goalAchieved = _dailyLog!.goalAchieved;
          _isLoading = false;
          _errorMessage = null;
          notifyListeners();
        },
      );
    } catch (e) {
      _errorMessage = 'Failed to initialize tracking:  $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load today's log
  Future<void> loadTodayLog() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getDailyIntakeUseCase(
      GetDailyIntakeParams(date: DateTime.now()),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (log) {
        _dailyLog = log;
        _goalAchieved = log.goalAchieved;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
    );
  }

  /// Add water intake
  Future<bool> addWater(double amount, {String? notes}) async {
    if (_dailyLog == null) {
      _errorMessage = 'Daily log not initialized';
      notifyListeners();
      return false;
    }

    try {
      final intake = WaterIntake(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        amount: amount,
        timestamp: DateTime.now(),
        notes: notes,
      );

      final result = await addWaterIntakeUseCase(
        AddWaterIntakeParams(intake: intake),
      );

      return result.fold(
        (failure) {
          _errorMessage = failure.message;
          notifyListeners();
          return false;
        },
        (_) async {
          // Reload today's log
          await loadTodayLog();
          return true;
        },
      );
    } catch (e) {
      _errorMessage = 'Failed to add water:  $e';
      notifyListeners();
      return false;
    }
  }

  /// Remove water intake
  Future<bool> removeWater(String intakeId) async {
    try {
      final result = await removeWaterIntakeUseCase(
        RemoveWaterIntakeParams(intakeId: intakeId),
      );

      return result.fold(
        (failure) {
          _errorMessage = failure.message;
          notifyListeners();
          return false;
        },
        (_) async {
          // Reload today's log
          await loadTodayLog();
          return true;
        },
      );
    } catch (e) {
      _errorMessage = 'Failed to remove water: $e';
      notifyListeners();
      return false;
    }
  }

  /// Load intake history
  Future<void> loadHistory(int days) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getIntakeHistoryUseCase(
      GetIntakeHistoryParams(days: days),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (history) {
        _logHistory = history;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
    );
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
