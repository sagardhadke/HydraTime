import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hydra_time/core/errors/failures.dart';
import 'package:hydra_time/core/usecases/usecase.dart';
import 'package:hydra_time/features/water_tracking/domain/entities/daily_log.dart';
import 'package:hydra_time/features/water_tracking/domain/repositories/water_tracking_repository.dart';

class GetIntakeHistory
    implements UseCase<List<DailyLog>, GetIntakeHistoryParams> {
  final WaterTrackingRepository repository;

  GetIntakeHistory({required this.repository});

  @override
  Future<Either<Failure, List<DailyLog>>> call(
    GetIntakeHistoryParams params,
  ) async {
    return await repository.getLogHistory(params.days);
  }
}

class GetIntakeHistoryParams extends Equatable {
  final int days;

  const GetIntakeHistoryParams({required this.days});

  @override
  List<Object?> get props => [days];
}
