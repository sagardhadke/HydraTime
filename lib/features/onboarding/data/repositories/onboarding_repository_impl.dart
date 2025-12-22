import 'package:dartz/dartz.dart';
import 'package:hydra_time/core/errors/exceptions.dart';
import 'package:hydra_time/core/errors/failures.dart';
import 'package:hydra_time/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:hydra_time/features/onboarding/data/models/onboarding_model.dart';
import 'package:hydra_time/features/onboarding/data/repositories/onboarding_repository.dart';
import 'package:hydra_time/features/onboarding/domain/entities/onboarding.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, bool>> isOnboardingCompleted() async {
    try {
      final status = await localDataSource.getOnboardingStatus();
      return Right(status.isCompleted);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> completeOnboarding() async {
    try {
      await localDataSource.completeOnboarding();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateCurrentPage(int page) async {
    try {
      await localDataSource.updateCurrentPage(page);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> getCurrentPage() async {
    try {
      final status = await localDataSource.getOnboardingStatus();
      return Right(status.currentPage);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Onboarding>>> getOnboardingPages() async {
    try {
      // Static onboarding content
      final pages = [
        const OnboardingContentModel(
          title: "Track your water timing",
          description: "Staying hydrated can improve cognitive function.",
          imagePath: "assets/images/onBoard1.png",
        ),
        const OnboardingContentModel(
          title: "Your body needs water",
          description: "Set daily water intake goals and track their progress.",
          imagePath: "assets/images/onBoard2.png",
        ),
        const OnboardingContentModel(
          title: "Know how you hydrated",
          description:
              "We provide personalised recommendations for how much water to drink based on the user's weight, age, and activity level.",
          imagePath: "assets/images/onBoard3.png",
        ),
      ];
      return Right(pages);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get onboarding pages: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resetOnboarding() async {
    try {
      await localDataSource.resetOnboarding();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }
}