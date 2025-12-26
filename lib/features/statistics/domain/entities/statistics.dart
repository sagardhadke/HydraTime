import 'package:equatable/equatable.dart';

class Statistics extends Equatable {
  final DateTime date;
  final double totalIntake;
  final double dailyGoal;
  final double percentage;
  final bool goalAchieved;
  final int intakesCount;

  const Statistics({
    required this.date,
    required this.totalIntake,
    required this.dailyGoal,
    required this.percentage,
    required this.goalAchieved,
    required this.intakesCount,
  });

  @override
  List<Object?> get props => [
    date,
    totalIntake,
    dailyGoal,
    percentage,
    goalAchieved,
    intakesCount,
  ];
}
