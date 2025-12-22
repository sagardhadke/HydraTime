import 'package:dartz/dartz.dart';
import 'package:hydra_time/core/errors/failures.dart';
import 'package:hydra_time/core/usecases/usecase.dart';
import 'package:hydra_time/features/onboarding/data/repositories/onboarding_repository.dart';
import 'package:hydra_time/features/onboarding/domain/entities/onboarding.dart';

class GetOnboardingPages implements UseCase<List<Onboarding>, NoParams> {
  final OnboardingRepository repository;

  GetOnboardingPages({required this.repository});

  @override
  Future<Either<Failure, List<Onboarding>>> call(NoParams params) async {
    return await repository.getOnboardingPages();
  }
}