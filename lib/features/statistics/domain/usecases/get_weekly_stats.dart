import 'package:dartz/dartz.dart';
import 'package:hydra_time/core/errors/failures.dart';
import 'package:hydra_time/core/usecases/usecase.dart';
import 'package:hydra_time/features/statistics/domain/repositories/statistics_repository.dart';

class GetWeeklyStats implements UseCase<Map<String, double>, NoParams> {
  final StatisticsRepository repository;

  GetWeeklyStats({required this.repository});

  @override
  Future<Either<Failure, Map<String, double>>> call(NoParams params) async {
    return await repository.getWeeklyStats();
  }
}
