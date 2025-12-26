import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hydra_time/core/errors/failures.dart';
import 'package:hydra_time/core/usecases/usecase.dart';
import 'package:hydra_time/features/statistics/domain/entities/statistics.dart';
import 'package:hydra_time/features/statistics/domain/repositories/statistics_repository.dart';

class GetDailyStatistics
    implements UseCase<List<Statistics>, GetDailyStatisticsParams> {
  final StatisticsRepository repository;

  GetDailyStatistics({required this.repository});

  @override
  Future<Either<Failure, List<Statistics>>> call(
    GetDailyStatisticsParams params,
  ) async {
    return await repository.getDailyStatistics(params.days);
  }
}

class GetDailyStatisticsParams extends Equatable {
  final int days;

  const GetDailyStatisticsParams({required this.days});

  @override
  List<Object?> get props => [days];
}
