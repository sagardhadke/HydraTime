import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hydra_time/core/errors/failures.dart';
import 'package:hydra_time/core/usecases/usecase.dart';
import 'package:hydra_time/features/onboarding/data/repositories/onboarding_repository.dart';

class UpdateCurrentPage implements UseCase<void, UpdateCurrentPageParams> {
  final OnboardingRepository repository;

  UpdateCurrentPage({required this.repository});

  @override
  Future<Either<Failure, void>> call(UpdateCurrentPageParams params) async {
    return await repository.updateCurrentPage(params.page);
  }
}

class UpdateCurrentPageParams extends Equatable {
  final int page;

  const UpdateCurrentPageParams({required this.page});

  @override
  List<Object?> get props => [page];
}