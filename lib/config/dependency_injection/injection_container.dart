import 'package:get_it/get_it.dart';
import 'package:hydra_time/core/services/notification_service.dart';
import 'package:hydra_time/core/services/shared_prefs_service.dart';
import 'package:hydra_time/core/theme/theme_provider.dart';
import 'package:hydra_time/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:hydra_time/features/onboarding/data/repositories/onboarding_repository.dart';
import 'package:hydra_time/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:hydra_time/features/onboarding/domain/usecases/check_onboarding_status.dart';
import 'package:hydra_time/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:hydra_time/features/onboarding/domain/usecases/get_onboarding_pages.dart';
import 'package:hydra_time/features/onboarding/domain/usecases/update_current_page.dart';
import 'package:hydra_time/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:hydra_time/features/user_profile/data/datasources/user_profile_local_datasource.dart';
import 'package:hydra_time/features/user_profile/data/repositories/user_profile_repository.dart';
import 'package:hydra_time/features/user_profile/data/repositories/user_profile_repository_impl.dart';
import 'package:hydra_time/features/user_profile/domain/usecases/calculate_water_goal.dart';
import 'package:hydra_time/features/user_profile/domain/usecases/get_user_profile.dart';
import 'package:hydra_time/features/user_profile/domain/usecases/save_user_profile.dart';
import 'package:hydra_time/features/user_profile/domain/usecases/update_user_profile.dart';
import 'package:hydra_time/features/user_profile/presentation/providers/user_profile_provider.dart';
import 'package:hydra_time/features/water_tracking/data/datasources/water_tracking_local_datasource.dart';
import 'package:hydra_time/features/water_tracking/data/repositories/water_tracking_repository_impl.dart';
import 'package:hydra_time/features/water_tracking/domain/repositories/water_tracking_repository.dart';
import 'package:hydra_time/features/water_tracking/domain/usecases/add_water_intake.dart';
import 'package:hydra_time/features/water_tracking/domain/usecases/get_daily_intake.dart';
import 'package:hydra_time/features/water_tracking/domain/usecases/get_intake_history.dart';
import 'package:hydra_time/features/water_tracking/domain/usecases/remove_water_intake.dart';
import 'package:hydra_time/features/water_tracking/presentation/providers/water_tracking_provider.dart';
import 'package:hydra_time/services/storage/hive_service.dart';
import 'package:hydra_time/services/storage/migration_service.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerLazySingleton<HiveService>(() => HiveService());

  sl.registerLazySingleton<MigrationService>(() => MigrationService());

  sl.registerLazySingleton<SharedPrefsService>(
    () => SharedPrefsService.instance,
  );

  sl.registerLazySingleton<NotificationService>(() => NotificationService());

  sl.registerLazySingleton<ThemeProvider>(() => ThemeProvider());
  sl.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImpl(hiveService: sl()),
  );

  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton(() => CheckOnboardingStatus(repository: sl()));
  sl.registerLazySingleton(() => CompleteOnboarding(repository: sl()));
  sl.registerLazySingleton(() => GetOnboardingPages(repository: sl()));
  sl.registerLazySingleton(() => UpdateCurrentPage(repository: sl()));

  sl.registerFactory(
    () => OnboardingProvider(
      checkOnboardingStatus: sl(),
      completeOnboarding: sl(),
      getOnboardingPages: sl(),
      updateCurrentPage: sl(),
    ),
  );
  sl.registerLazySingleton<UserProfileLocalDataSource>(
    () => UserProfileLocalDataSourceImpl(hiveService: sl()),
  );

  sl.registerLazySingleton<UserProfileRepository>(
    () => UserProfileRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetUserProfile(repository: sl()));
  sl.registerLazySingleton(() => SaveUserProfile(repository: sl()));
  sl.registerLazySingleton(() => UpdateUserProfile(repository: sl()));
  sl.registerLazySingleton(() => CalculateWaterGoal(repository: sl()));

  sl.registerFactory(
    () => UserProfileProvider(
      getUserProfileUseCase: sl(),
      saveUserProfileUseCase: sl(),
      updateUserProfileUseCase: sl(),
      calculateWaterGoalUseCase: sl(),
    ),
  );
  sl.registerLazySingleton<WaterTrackingLocalDataSource>(
    () => WaterTrackingLocalDataSourceImpl(hiveService: sl()),
  );

  sl.registerLazySingleton<WaterTrackingRepository>(
    () => WaterTrackingRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetDailyIntake(repository: sl()));
  sl.registerLazySingleton(() => AddWaterIntake(repository: sl()));
  sl.registerLazySingleton(() => RemoveWaterIntake(repository: sl()));
  sl.registerLazySingleton(() => GetIntakeHistory(repository: sl()));

  sl.registerFactory(
    () => WaterTrackingProvider(
      getDailyIntakeUseCase: sl(),
      addWaterIntakeUseCase: sl(),
      removeWaterIntakeUseCase: sl(),
      getIntakeHistoryUseCase: sl(),
    ),
  );
}
