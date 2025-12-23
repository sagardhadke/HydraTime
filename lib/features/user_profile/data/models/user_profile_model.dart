import 'package:hive/hive.dart';
import 'package:hydra_time/core/constants/hive_type_ids.dart';
import 'package:hydra_time/features/user_profile/domain/entities/user_profile.dart';

part 'user_profile_model.g.dart';

@HiveType(typeId: HiveTypeIds.userProfile)
class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.fullName,
    required super.dateOfBirth,
    required super.gender,
    required super.wakeUpTime,
    required super.bedTime,
    required super.height,
    required super.weight,
    required super.activityLevel,
    required super.climate,
    required super.dailyWaterGoal,
    super.createdAt,
    super.updatedAt,
  });

  factory UserProfileModel.initial() {
    return const UserProfileModel(
      fullName: '',
      dateOfBirth: '',
      gender: '',
      wakeUpTime: '',
      bedTime: '',
      height: '',
      weight: '',
      activityLevel: '',
      climate: '',
      dailyWaterGoal: 0.0,
    );
  }

  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      fullName: entity.fullName,
      dateOfBirth: entity.dateOfBirth,
      gender: entity.gender,
      wakeUpTime: entity.wakeUpTime,
      bedTime: entity.bedTime,
      height: entity.height,
      weight: entity.weight,
      activityLevel: entity.activityLevel,
      climate: entity.climate,
      dailyWaterGoal: entity.dailyWaterGoal,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  UserProfileModel copyWith({
    String? fullName,
    String? dateOfBirth,
    String? gender,
    String? wakeUpTime,
    String? bedTime,
    String? height,
    String? weight,
    String? activityLevel,
    String? climate,
    double? dailyWaterGoal,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfileModel(
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      wakeUpTime: wakeUpTime ?? this.wakeUpTime,
      bedTime: bedTime ?? this.bedTime,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      activityLevel: activityLevel ?? this.activityLevel,
      climate: climate ?? this.climate,
      dailyWaterGoal: dailyWaterGoal ?? this.dailyWaterGoal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'dateOfBirth': dateOfBirth,
        'gender': gender,
        'wakeUpTime': wakeUpTime,
        'bedTime': bedTime,
        'height': height,
        'weight': weight,
        'activityLevel': activityLevel,
        'climate': climate,
        'dailyWaterGoal': dailyWaterGoal,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      fullName: json['fullName'] as String? ?? '',
      dateOfBirth: json['dateOfBirth'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      wakeUpTime: json['wakeUpTime'] as String? ?? '',
      bedTime: json['bedTime'] as String? ?? '',
      height: json['height'] as String? ?? '',
      weight: json['weight'] as String? ?? '',
      activityLevel: json['activityLevel'] as String? ?? '',
      climate: json['climate'] as String? ?? '',
      dailyWaterGoal: (json['dailyWaterGoal'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }
}