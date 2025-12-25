import 'package:equatable/equatable.dart';
import 'package:hydra_time/features/water_tracking/domain/entities/water_intake.dart';

class DailyLog extends Equatable {
  final DateTime date;
  final List<WaterIntake> intakes;
  final double dailyGoal;
  final double totalIntake;

  const DailyLog({
    required this.date,
    required this.intakes,
    required this.dailyGoal,
    required this.totalIntake,
  });

  bool get goalAchieved => totalIntake >= dailyGoal;

  double get percentage => dailyGoal > 0 ? (totalIntake / dailyGoal) * 100 : 0;

  int get remainingMl {
    if (dailyGoal <= 0) return 0;
    final remaining = dailyGoal - totalIntake;
    if (remaining.isNaN || remaining.isInfinite) return 0;
    if (remaining < 0) return 0;
    return remaining.toInt();
  }

  DailyLog copyWith({
    DateTime? date,
    List<WaterIntake>? intakes,
    double? dailyGoal,
    double? totalIntake,
  }) {
    return DailyLog(
      date: date ?? this.date,
      intakes: intakes ?? this.intakes,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      totalIntake: totalIntake ?? this.totalIntake,
    );
  }

  @override
  List<Object?> get props => [date, intakes, dailyGoal, totalIntake];
}
