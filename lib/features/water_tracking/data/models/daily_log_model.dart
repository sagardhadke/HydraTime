import 'package:hive/hive.dart';
import 'package:hydra_time/core/constants/hive_type_ids.dart';
import 'package:hydra_time/features/water_tracking/data/models/water_intake_model.dart';
import 'package:hydra_time/features/water_tracking/domain/entities/daily_log.dart';
import 'package:hydra_time/features/water_tracking/domain/entities/water_intake.dart';

part 'daily_log_model.g.dart';

@HiveType(typeId: HiveTypeIds.dailyLog)
class DailyLogModel extends DailyLog {
  const DailyLogModel({
    required super.date,
    required super.intakes,
    required super.dailyGoal,
    required super.totalIntake,
  });

  factory DailyLogModel.initial({required double dailyGoal}) {
    final validGoal = dailyGoal > 0 ? dailyGoal : 2000.0;

    return DailyLogModel(
      date: DateTime.now(),
      intakes: [],
      dailyGoal: validGoal,
      totalIntake: 0.0,
    );
  }

  factory DailyLogModel.fromEntity(DailyLog entity) {
    return DailyLogModel(
      date: entity.date,
      intakes: entity.intakes,
      dailyGoal: entity.dailyGoal > 0 ? entity.dailyGoal : 2000.0,
      totalIntake: entity.totalIntake >= 0 ? entity.totalIntake : 0.0,
    );
  }

  DailyLogModel copyWith({
    DateTime? date,
    List<WaterIntake>? intakes,
    double? dailyGoal,
    double? totalIntake,
  }) {
    return DailyLogModel(
      date: date ?? this.date,
      intakes: intakes ?? this.intakes,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      totalIntake: totalIntake ?? this.totalIntake,
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'intakes': intakes
        .map((intake) => (intake as WaterIntakeModel).toJson())
        .toList(),
    'dailyGoal': dailyGoal,
    'totalIntake': totalIntake,
  };

  factory DailyLogModel.fromJson(Map<String, dynamic> json) {
    final intakesList =
        (json['intakes'] as List?)
            ?.map(
              (intake) =>
                  WaterIntakeModel.fromJson(intake as Map<String, dynamic>),
            )
            .toList() ??
        [];

    final dailyGoal = (json['dailyGoal'] as num?)?.toDouble() ?? 2000.0;
    final totalIntake = (json['totalIntake'] as num?)?.toDouble() ?? 0.0;

    final validGoal = dailyGoal > 0 ? dailyGoal : 2000.0;
    final validIntake = totalIntake >= 0 ? totalIntake : 0.0;

    return DailyLogModel(
      date: DateTime.parse(json['date'] as String),
      intakes: intakesList,
      dailyGoal: validGoal,
      totalIntake: validIntake,
    );
  }
}
