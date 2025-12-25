import 'package:dartz/dartz.dart';
import 'package:hydra_time/core/errors/failures.dart';
import 'package:hydra_time/features/water_tracking/domain/entities/daily_log.dart';
import 'package:hydra_time/features/water_tracking/domain/entities/water_intake.dart';

abstract class WaterTrackingRepository {
  Future<Either<Failure, DailyLog>> getDailyLog(DateTime date);
  Future<Either<Failure, void>> addWaterIntake(WaterIntake intake);
  Future<Either<Failure, void>> removeWaterIntake(String intakeId);
  Future<Either<Failure, void>> resetDailyLog(DateTime date);
  Future<Either<Failure, List<DailyLog>>> getLogHistory(int days);
}
