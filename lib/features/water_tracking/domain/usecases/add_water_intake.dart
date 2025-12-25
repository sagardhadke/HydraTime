import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hydra_time/core/errors/failures.dart';
import 'package:hydra_time/core/usecases/usecase.dart';
import 'package:hydra_time/features/water_tracking/domain/entities/water_intake.dart';
import 'package:hydra_time/features/water_tracking/domain/repositories/water_tracking_repository.dart';

class AddWaterIntake implements UseCase<void, AddWaterIntakeParams> {
  final WaterTrackingRepository repository;

  AddWaterIntake({required this.repository});

  @override
  Future<Either<Failure, void>> call(AddWaterIntakeParams params) async {
    return await repository.addWaterIntake(params.intake);
  }
}

class AddWaterIntakeParams extends Equatable {
  final WaterIntake intake;

  const AddWaterIntakeParams({required this.intake});

  @override
  List<Object?> get props => [intake];
}
