import 'package:dartz/dartz.dart';
import 'package:hydra_time/core/errors/failures.dart';
import 'package:hydra_time/core/usecases/usecase.dart';
import 'package:hydra_time/features/user_profile/data/repositories/user_profile_repository.dart';
import 'package:hydra_time/features/user_profile/domain/entities/user_profile.dart';

class GetUserProfile implements UseCase<UserProfile, NoParams> {
  final UserProfileRepository repository;

  GetUserProfile({required this.repository});

  @override
  Future<Either<Failure, UserProfile>> call(NoParams params) async {
    return await repository.getUserProfile();
  }
}