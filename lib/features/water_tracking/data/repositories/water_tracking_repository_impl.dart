import 'package:dartz/dartz.dart';
import 'package:hydra_time/core/errors/exceptions.dart';
import 'package:hydra_time/core/errors/failures.dart';
import 'package:hydra_time/features/water_tracking/data/datasources/water_tracking_local_datasource.dart';
import 'package:hydra_time/features/water_tracking/data/models/water_intake_model.dart';
import 'package:hydra_time/features/water_tracking/domain/entities/daily_log.dart';
import 'package:hydra_time/features/water_tracking/domain/entities/water_intake.dart';
import 'package:hydra_time/features/water_tracking/domain/repositories/water_tracking_repository.dart';

class WaterTrackingRepositoryImpl implements WaterTrackingRepository {
  final WaterTrackingLocalDataSource localDataSource;

  WaterTrackingRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, DailyLog>> getDailyLog(DateTime date) async {
    try {
      final log = await localDataSource.getDailyLog(date);
      return Right(log);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> addWaterIntake(WaterIntake intake) async {
    try {
      final model = WaterIntakeModel.fromEntity(intake);
      await localDataSource.addWaterIntake(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> removeWaterIntake(String intakeId) async {
    try {
      await localDataSource.removeWaterIntake(intakeId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resetDailyLog(DateTime date) async {
    try {
      await localDataSource.resetDailyLog(date);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error:  $e'));
    }
  }

  @override
  Future<Either<Failure, List<DailyLog>>> getLogHistory(int days) async {
    try {
      final logs = await localDataSource.getLogHistory(days);
      return Right(logs);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }
}
