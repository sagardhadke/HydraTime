import 'package:equatable/equatable.dart';

class WaterIntake extends Equatable {
  final String id;
  final double amount; // in milliliters
  final DateTime timestamp;
  final String?  notes;

  const WaterIntake({
    required this.id,
    required this.amount,
    required this. timestamp,
    this.notes,
  });

  @override
  List<Object?> get props => [id, amount, timestamp, notes];
}