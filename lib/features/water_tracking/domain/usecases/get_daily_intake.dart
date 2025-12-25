import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hydra_time/core/errors/failures.dart';
import 'package:hydra_time/core/usecases/usecase.dart';
import 'package:hydra_time/features/water_tracking/domain/entities/daily_log.dart';
import 'package:hydra_time/features/water_tracking/domain/repositories/water_tracking_repository.dart';

class GetDailyIntake implements UseCase<DailyLog, GetDailyIntakeParams> {
  final WaterTrackingRepository repository;

  GetDailyIntake({required this.repository});

  @override
  Future<Either<Failure, DailyLog>> call(GetDailyIntakeParams params) async {
    return await repository.getDailyLog(params.date);
  }
}

class GetDailyIntakeParams extends Equatable {
  final DateTime date;

  const GetDailyIntakeParams({required this. date});

  @override
  List<Object? > get props => [date];
}