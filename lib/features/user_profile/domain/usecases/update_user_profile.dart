import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hydra_time/core/errors/failures.dart';
import 'package:hydra_time/core/usecases/usecase.dart';
import 'package:hydra_time/features/user_profile/data/repositories/user_profile_repository.dart';
import 'package:hydra_time/features/user_profile/domain/entities/user_profile.dart';

class UpdateUserProfile implements UseCase<void, UpdateUserProfileParams> {
  final UserProfileRepository repository;

  UpdateUserProfile({required this.repository});

  @override
  Future<Either<Failure, void>> call(UpdateUserProfileParams params) async {
    return await repository.updateUserProfile(params.profile);
  }
}

class UpdateUserProfileParams extends Equatable {
  final UserProfile profile;

  const UpdateUserProfileParams({required this.profile});

  @override
  List<Object?> get props => [profile];
}