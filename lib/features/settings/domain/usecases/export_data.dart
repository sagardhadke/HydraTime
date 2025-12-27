import 'package:dartz/dartz.dart';
import 'package:hydra_time/core/errors/failures.dart';
import 'package:hydra_time/core/usecases/usecase.dart';
import 'package:hydra_time/features/settings/domain/repositories/settings_repository.dart';

class ExportData implements UseCase<String, NoParams> {
  final SettingsRepository repository;

  ExportData({required this.repository});

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await repository.exportData();
  }
}
