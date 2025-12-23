import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hydra_time/core/errors/failures.dart';
import 'package:hydra_time/core/usecases/usecase.dart';
import 'package:hydra_time/features/user_profile/data/repositories/user_profile_repository.dart';

class CalculateWaterGoal implements UseCase<double, CalculateWaterGoalParams> {
  final UserProfileRepository repository;

  CalculateWaterGoal({required this.repository});

  @override
  Future<Either<Failure, double>> call(CalculateWaterGoalParams params) async {
    return await repository.calculateWaterGoal(
      weight: params.weight,
      activityLevel: params.activityLevel,
      climate: params.climate,
    );
  }
}

class CalculateWaterGoalParams extends Equatable {
  final double weight;
  final String activityLevel;
  final String climate;

  const CalculateWaterGoalParams({
    required this.weight,
    required this.activityLevel,
    required this.climate,
  });

  @override
  List<Object?> get props => [weight, activityLevel, climate];
}
