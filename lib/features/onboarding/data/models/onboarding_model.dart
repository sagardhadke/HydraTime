import 'package:hive/hive.dart';
import 'package:hydra_time/core/constants/hive_type_ids.dart';
import 'package:hydra_time/features/onboarding/domain/entities/onboarding.dart';

part 'onboarding_model.g.dart';

@HiveType(typeId: HiveTypeIds.onboardingStatus)
class OnboardingModel extends HiveObject {
  @HiveField(0)
  final bool isCompleted;

  @HiveField(1)
  final DateTime? completedAt;

  @HiveField(2)
  final int currentPage;

  OnboardingModel({
    required this.isCompleted,
    this.completedAt,
    this.currentPage = 0,
  });

  factory OnboardingModel.initial() {
    return OnboardingModel(
      isCompleted: false,
      completedAt: null,
      currentPage: 0,
    );
  }

  OnboardingModel copyWith({
    bool? isCompleted,
    DateTime? completedAt,
    int? currentPage,
  }) {
    return OnboardingModel(
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  Map<String, dynamic> toJson() => {
        'isCompleted': isCompleted,
        'completedAt': completedAt?.toIso8601String(),
        'currentPage': currentPage,
      };

  factory OnboardingModel.fromJson(Map<String, dynamic> json) {
    return OnboardingModel(
      isCompleted: json['isCompleted'] as bool,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      currentPage: json['currentPage'] as int? ?? 0,
    );
  }
}

// Onboarding content model
class OnboardingContentModel extends Onboarding {
  const OnboardingContentModel({
    required super.title,
    required super.description,
    required super.imagePath,
  });

  factory OnboardingContentModel.fromEntity(Onboarding entity) {
    return OnboardingContentModel(
      title: entity.title,
      description: entity.description,
      imagePath: entity.imagePath,
    );
  }
}