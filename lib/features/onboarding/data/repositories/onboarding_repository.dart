import 'package:dartz/dartz.dart';
import 'package:hydra_time/core/errors/failures.dart';
import 'package:hydra_time/features/onboarding/domain/entities/onboarding.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, bool>> isOnboardingCompleted();
  Future<Either<Failure, void>> completeOnboarding();
  Future<Either<Failure, void>> updateCurrentPage(int page);
  Future<Either<Failure, int>> getCurrentPage();
  Future<Either<Failure, List<Onboarding>>> getOnboardingPages();
  Future<Either<Failure, void>> resetOnboarding();
}