import 'package:equatable/equatable.dart';

class WaterIntake extends Equatable {
  final String id;
  final double amount; // in milliliters
  final DateTime timestamp;
  final String? notes;

  const WaterIntake({
    required this.id,
    required this.amount,
    required this.timestamp,
    this.notes,
  });

  /// Copy with method to create a new instance with updated fields
  WaterIntake copyWith({
    String? id,
    double? amount,
    DateTime? timestamp,
    String? notes,
  }) {
    return WaterIntake(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      timestamp: timestamp ?? this.timestamp,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [id, amount, timestamp, notes];
}
