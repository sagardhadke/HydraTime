import 'package:hive/hive.dart';
import 'package:hydra_time/core/constants/hive_type_ids.dart';
import 'package:hydra_time/features/statistics/domain/entities/statistics.dart';

part 'statistics_model.g.dart';

@HiveType(typeId: HiveTypeIds.statistics)
class StatisticsModel extends Statistics {
  const StatisticsModel({
    required super.date,
    required super.totalIntake,
    required super.dailyGoal,
    required super.percentage,
    required super.goalAchieved,
    required super.intakesCount,
  });

  factory StatisticsModel.fromEntity(Statistics entity) {
    return StatisticsModel(
      date: entity.date,
      totalIntake: entity.totalIntake,
      dailyGoal: entity.dailyGoal,
      percentage: entity.percentage,
      goalAchieved: entity.goalAchieved,
      intakesCount: entity.intakesCount,
    );
  }

  StatisticsModel copyWith({
    DateTime? date,
    double? totalIntake,
    double? dailyGoal,
    double? percentage,
    bool? goalAchieved,
    int? intakesCount,
  }) {
    return StatisticsModel(
      date: date ?? this.date,
      totalIntake: totalIntake ?? this.totalIntake,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      percentage: percentage ?? this.percentage,
      goalAchieved: goalAchieved ?? this.goalAchieved,
      intakesCount: intakesCount ?? this.intakesCount,
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'totalIntake': totalIntake,
    'dailyGoal': dailyGoal,
    'percentage': percentage,
    'goalAchieved': goalAchieved,
    'intakesCount': intakesCount,
  };

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      date: DateTime.parse(json['date'] as String),
      totalIntake: (json['totalIntake'] as num?)?.toDouble() ?? 0.0,
      dailyGoal: (json['dailyGoal'] as num?)?.toDouble() ?? 2000.0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      goalAchieved: json['goalAchieved'] as bool? ?? false,
      intakesCount: json['intakesCount'] as int? ?? 0,
    );
  }
}
