import 'package:dartz/dartz.dart';
import 'package:hydra_time/core/errors/exceptions.dart';
import 'package:hydra_time/core/errors/failures.dart';
import 'package:hydra_time/core/utils/water_calculator.dart';
import 'package:hydra_time/features/user_profile/data/datasources/user_profile_local_datasource.dart';
import 'package:hydra_time/features/user_profile/data/models/user_profile_model.dart';
import 'package:hydra_time/features/user_profile/data/repositories/user_profile_repository.dart';
import 'package:hydra_time/features/user_profile/domain/entities/user_profile.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileLocalDataSource localDataSource;

  UserProfileRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, UserProfile>> getUserProfile() async {
    try {
      final profile = await localDataSource.getUserProfile();
      return Right(profile);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveUserProfile(UserProfile profile) async {
    try {
      final model = UserProfileModel.fromEntity(profile);
      await localDataSource.saveUserProfile(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserProfile(UserProfile profile) async {
    try {
      final model = UserProfileModel.fromEntity(profile);
      await localDataSource.updateUserProfile(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUserProfile() async {
    try {
      await localDataSource.deleteUserProfile();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> hasUserProfile() async {
    try {
      final hasProfile = await localDataSource.hasUserProfile();
      return Right(hasProfile);
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, double>> calculateWaterGoal({
    required double weight,
    required String activityLevel,
    required String climate,
  }) async {
    try {
      final goal = WaterCalculator.calculateDailyGoal(
        weightKg: weight,
        activityLevel: activityLevel,
        climate: climate,
      );
      return Right(goal);
    } catch (e) {
      return Left(DataNotFoundFailure(message: 'Failed to calculate water goal: $e'));
    }
  }
}