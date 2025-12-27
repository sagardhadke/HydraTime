import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hydra_time/core/errors/failures.dart';
import 'package:hydra_time/core/usecases/usecase.dart';
import 'package:hydra_time/features/settings/domain/repositories/settings_repository.dart';

class UpdateTheme implements UseCase<void, UpdateThemeParams> {
  final SettingsRepository repository;

  UpdateTheme({required this.repository});

  @override
  Future<Either<Failure, void>> call(UpdateThemeParams params) async {
    return await repository.updateTheme(params.themeMode);
  }
}

class UpdateThemeParams extends Equatable {
  final String themeMode;

  const UpdateThemeParams({required this.themeMode});

  @override
  List<Object?> get props => [themeMode];
}
