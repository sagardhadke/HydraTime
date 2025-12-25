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

  int get remainingMl =>
      ((dailyGoal - totalIntake).toInt()).clamp(0, double.infinity.toInt());

  @override
  List<Object?> get props => [date, intakes, dailyGoal, totalIntake];
}
