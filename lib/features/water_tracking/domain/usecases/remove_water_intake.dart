import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hydra_time/core/errors/failures.dart';
import 'package:hydra_time/core/usecases/usecase.dart';
import 'package:hydra_time/features/water_tracking/domain/repositories/water_tracking_repository.dart';

class RemoveWaterIntake implements UseCase<void, RemoveWaterIntakeParams> {
  final WaterTrackingRepository repository;

  RemoveWaterIntake({required this.repository});

  @override
  Future<Either<Failure, void>> call(RemoveWaterIntakeParams params) async {
    return await repository.removeWaterIntake(params.intakeId);
  }
}

class RemoveWaterIntakeParams extends Equatable {
  final String intakeId;

  const RemoveWaterIntakeParams({required this.intakeId});

  @override
  List<Object?> get props => [intakeId];
}
