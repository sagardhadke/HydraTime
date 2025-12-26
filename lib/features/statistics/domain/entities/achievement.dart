import 'package:equatable/equatable.dart';

enum AchievementType {
  firstDrop, // First water intake
  weekStreak, // 7 days of goal achievement
  monthStreak, // 30 days of goal achievement
  halfLiter, // Intake 500ml in a day
  oneLiter, // Intake 1000ml in a day
  twoLiter, // Intake 2000ml in a day
  threeLiter, // Intake 3000ml in a day
  earlyBird, // 3 glasses before 9am
  perfectWeek, // Achieved goal for 7 consecutive days
  perfectMonth, // Achieved goal for 30 consecutive days
}

class Achievement extends Equatable {
  final String id;
  final AchievementType type;
  final String title;
  final String description;
  final String icon;
  final DateTime unlockedAt;
  final bool isUnlocked;

  const Achievement({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    required this.unlockedAt,
    required this.isUnlocked,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    title,
    description,
    icon,
    unlockedAt,
    isUnlocked,
  ];
}
