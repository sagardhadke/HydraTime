import 'package:dartz/dartz.dart';
import 'package:hydra_time/core/errors/failures.dart';
import 'package:hydra_time/core/usecases/usecase.dart';
import 'package:hydra_time/features/onboarding/data/repositories/onboarding_repository.dart';

class CheckOnboardingStatus implements UseCase<bool, NoParams> {
  final OnboardingRepository repository;

  CheckOnboardingStatus({required this.repository});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.isOnboardingCompleted();
  }
}