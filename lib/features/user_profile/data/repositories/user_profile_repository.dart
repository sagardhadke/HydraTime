import 'package:dartz/dartz.dart';
import 'package:hydra_time/core/errors/failures.dart';
import 'package:hydra_time/features/user_profile/domain/entities/user_profile.dart';

abstract class UserProfileRepository {
  Future<Either<Failure, UserProfile>> getUserProfile();
  Future<Either<Failure, void>> saveUserProfile(UserProfile profile);
  Future<Either<Failure, void>> updateUserProfile(UserProfile profile);
  Future<Either<Failure, void>> deleteUserProfile();
  Future<Either<Failure, bool>> hasUserProfile();
  Future<Either<Failure, double>> calculateWaterGoal({
    required double weight,
    required String activityLevel,
    required String climate,
  });
}