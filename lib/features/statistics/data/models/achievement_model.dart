import 'package:hive/hive.dart';
import 'package:hydra_time/core/constants/hive_type_ids.dart';
import 'package:hydra_time/features/statistics/domain/entities/achievement.dart';

part 'achievement_model.g.dart';

@HiveType(typeId: HiveTypeIds.achievement)
class AchievementModel extends Achievement {
  const AchievementModel({
    required super.id,
    required super.type,
    required super.title,
    required super.description,
    required super.icon,
    required super.unlockedAt,
    required super.isUnlocked,
  });

  factory AchievementModel.fromEntity(Achievement entity) {
    return AchievementModel(
      id: entity.id,
      type: entity.type,
      title: entity.title,
      description: entity.description,
      icon: entity.icon,
      unlockedAt: entity.unlockedAt,
      isUnlocked: entity.isUnlocked,
    );
  }

  AchievementModel copyWith({
    String? id,
    AchievementType? type,
    String? title,
    String? description,
    String? icon,
    DateTime? unlockedAt,
    bool? isUnlocked,
  }) {
    return AchievementModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'title': title,
    'description': description,
    'icon': icon,
    'unlockedAt': unlockedAt.toIso8601String(),
    'isUnlocked': isUnlocked,
  };

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as String,
      type: AchievementType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AchievementType.firstDrop,
      ),
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      unlockedAt: DateTime.parse(json['unlockedAt'] as String),
      isUnlocked: json['isUnlocked'] as bool? ?? false,
    );
  }
}
