import 'package:dartz/dartz.dart';
import 'package:hydra_time/core/errors/failures.dart';
import 'package:hydra_time/features/settings/domain/entities/app_settings.dart';

abstract class SettingsRepository {
  Future<Either<Failure, AppSettings>> getSettings();
  Future<Either<Failure, void>> saveSettings(AppSettings settings);
  Future<Either<Failure, void>> updateTheme(String themeMode);
  Future<Either<Failure, void>> updateNotifications(bool enabled);
  Future<Either<Failure, void>> updateSound(bool enabled);
  Future<Either<Failure, void>> updateVibration(bool enabled);
  Future<Either<Failure, void>> updateLanguage(String language);
  Future<Either<Failure, void>> clearAllSettings();
  Future<Either<Failure, String>> exportData();
  Future<Either<Failure, void>> importData(String jsonData);
}
