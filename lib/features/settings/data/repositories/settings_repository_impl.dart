import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:hydra_time/core/errors/exceptions.dart';
import 'package:hydra_time/core/errors/failures.dart';
import 'package:hydra_time/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:hydra_time/features/settings/data/models/settings_model.dart';
import 'package:hydra_time/features/settings/domain/entities/app_settings.dart';
import 'package:hydra_time/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, AppSettings>> getSettings() async {
    try {
      final settings = await localDataSource.getSettings();
      return Right(settings);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveSettings(AppSettings settings) async {
    try {
      final model = SettingsModel.fromEntity(settings);
      await localDataSource.saveSettings(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateTheme(String themeMode) async {
    try {
      final currentSettings = await localDataSource.getSettings();
      final updated = currentSettings.copyWith(themeMode: themeMode);
      await localDataSource.saveSettings(updated);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateNotifications(bool enabled) async {
    try {
      final currentSettings = await localDataSource.getSettings();
      final updated = currentSettings.copyWith(notificationsEnabled: enabled);
      await localDataSource.saveSettings(updated);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateSound(bool enabled) async {
    try {
      final currentSettings = await localDataSource.getSettings();
      final updated = currentSettings.copyWith(soundEnabled: enabled);
      await localDataSource.saveSettings(updated);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateVibration(bool enabled) async {
    try {
      final currentSettings = await localDataSource.getSettings();
      final updated = currentSettings.copyWith(vibrationEnabled: enabled);
      await localDataSource.saveSettings(updated);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateLanguage(String language) async {
    try {
      final currentSettings = await localDataSource.getSettings();
      final updated = currentSettings.copyWith(language: language);
      await localDataSource.saveSettings(updated);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error:  $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearAllSettings() async {
    try {
      await localDataSource.clearAllSettings();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> exportData() async {
    try {
      final settings = await localDataSource.getSettings();
      final jsonString = jsonEncode(settings.toJson());
      return Right(jsonString);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> importData(String jsonData) async {
    try {
      final json = jsonDecode(jsonData) as Map<String, dynamic>;
      final settings = SettingsModel.fromJson(json);
      await localDataSource.saveSettings(settings);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }
}
