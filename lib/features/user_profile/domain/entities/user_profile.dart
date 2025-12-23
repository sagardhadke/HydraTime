import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String fullName;
  final String dateOfBirth;
  final String gender;
  final String wakeUpTime;
  final String bedTime;
  final String height;
  final String weight;
  final String activityLevel;
  final String climate;
  final double dailyWaterGoal;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserProfile({
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    required this.wakeUpTime,
    required this.bedTime,
    required this.height,
    required this.weight,
    required this.activityLevel,
    required this.climate,
    required this.dailyWaterGoal,
    this.createdAt,
    this.updatedAt,
  });

  bool get isComplete {
    return fullName.isNotEmpty &&
        dateOfBirth.isNotEmpty &&
        gender.isNotEmpty &&
        wakeUpTime.isNotEmpty &&
        bedTime.isNotEmpty &&
        height.isNotEmpty &&
        weight.isNotEmpty &&
        activityLevel.isNotEmpty &&
        climate.isNotEmpty &&
        dailyWaterGoal > 0;
  }

  @override
  List<Object?> get props => [
        fullName,
        dateOfBirth,
        gender,
        wakeUpTime,
        bedTime,
        height,
        weight,
        activityLevel,
        climate,
        dailyWaterGoal,
        createdAt,
        updatedAt,
      ];
}