import 'package:hive/hive.dart';
import 'package:hydra_time/core/constants/hive_type_ids.dart';
import 'package:hydra_time/features/water_tracking/domain/entities/water_intake.dart';

part 'water_intake_model.g.dart';

@HiveType(typeId: HiveTypeIds.waterIntake)
class WaterIntakeModel extends WaterIntake {
  const WaterIntakeModel({
    required super.id,
    required super.amount,
    required super.timestamp,
    super.notes,
  });

  factory WaterIntakeModel.fromEntity(WaterIntake entity) {
    return WaterIntakeModel(
      id: entity.id,
      amount: entity.amount,
      timestamp: entity.timestamp,
      notes: entity.notes,
    );
  }

  WaterIntakeModel copyWith({
    String? id,
    double? amount,
    DateTime? timestamp,
    String? notes,
  }) {
    return WaterIntakeModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      timestamp: timestamp ?? this.timestamp,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'timestamp': timestamp.toIso8601String(),
    'notes': notes,
  };

  factory WaterIntakeModel.fromJson(Map<String, dynamic> json) {
    return WaterIntakeModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      notes: json['notes'] as String?,
    );
  }
}
