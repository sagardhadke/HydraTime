import 'package:dartz/dartz.dart';
import 'package:hydra_time/core/errors/failures.dart';
import 'package:hydra_time/core/usecases/usecase.dart';
import 'package:hydra_time/features/statistics/domain/repositories/statistics_repository.dart';

class GetStreak implements UseCase<double, NoParams> {
  final StatisticsRepository repository;

  GetStreak({required this.repository});

  @override
  Future<Either<Failure, double>> call(NoParams params) async {
    return await repository.calculateStreak();
  }
}
