import 'package:dartz/dartz.dart';
import 'package:hydra_time/core/errors/failures.dart';
import 'package:hydra_time/core/usecases/usecase.dart';
import 'package:hydra_time/features/statistics/domain/entities/achievement.dart';
import 'package:hydra_time/features/statistics/domain/repositories/statistics_repository.dart';

class GetAchievements implements UseCase<List<Achievement>, NoParams> {
  final StatisticsRepository repository;

  GetAchievements({required this.repository});

  @override
  Future<Either<Failure, List<Achievement>>> call(NoParams params) async {
    return await repository.getAchievements();
  }
}
