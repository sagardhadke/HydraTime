import 'package:dartz/dartz.dart';
import 'package:hydra_time/core/errors/failures.dart';
import 'package:hydra_time/core/usecases/usecase.dart';
import 'package:hydra_time/features/settings/domain/repositories/settings_repository.dart';

class ClearAllData implements UseCase<void, NoParams> {
  final SettingsRepository repository;

  ClearAllData({required this.repository});

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.clearAllSettings();
  }
}
