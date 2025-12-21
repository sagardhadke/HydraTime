import 'package:get_it/get_it.dart';
import 'package:hydra_time/core/services/notification_service.dart';
import 'package:hydra_time/core/services/shared_prefs_service.dart';
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
}
