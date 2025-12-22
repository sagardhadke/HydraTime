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

  // Repositories
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(localDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => CheckOnboardingStatus(repository: sl()));
  sl.registerLazySingleton(() => CompleteOnboarding(repository: sl()));
  sl.registerLazySingleton(() => GetOnboardingPages(repository: sl()));
  sl.registerLazySingleton(() => UpdateCurrentPage(repository: sl()));

  // Provider
  sl.registerFactory(
    () => OnboardingProvider(
      checkOnboardingStatus: sl(),
      completeOnboarding: sl(),
      getOnboardingPages: sl(),
      updateCurrentPage: sl(),
    ),
  );
}
