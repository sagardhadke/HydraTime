import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydra_time/Routes/app_routes.dart';
import 'package:hydra_time/config/dependency_injection/injection_container.dart';
import 'package:hydra_time/core/services/notification_service.dart';
import 'package:hydra_time/core/theme/app_themes.dart';
import 'package:hydra_time/provider/about_us_provider.dart';
import 'package:hydra_time/provider/myOnBoarding_provider.dart';
import 'package:hydra_time/provider/reminders_provider.dart';
import 'package:hydra_time/services/storage/hive_service.dart';
import 'package:hydra_time/services/storage/migration_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  try {
    await initializeDependencies();
    debugPrint('✅ Dependency Injection initialized');

    final hiveService = sl<HiveService>();
    await hiveService.init();
    await hiveService.registerAdapters();
    await hiveService.openBoxes();
    debugPrint('✅ Hive initialized and boxes opened');

    final migrationService = sl<MigrationService>();
    if (await migrationService.needsMigration()) {
      debugPrint('🔄 Migration needed, starting migration...');
      await migrationService.migrateFromSharedPreferences();
      debugPrint('✅ Migration completed successfully');
    } else {
      debugPrint('✅ No migration needed');
    }

    final notificationService = sl<NotificationService>();
    await notificationService.initNotification();
    debugPrint('✅ Notifications initialized');

    runApp(const MyApp());
  } catch (e, stackTrace) {
    debugPrint('❌ Fatal error during initialization: $e');
    debugPrint('Stack trace: $stackTrace');

    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 80, color: Colors.red),
                  const SizedBox(height: 20),
                  const Text(
                    'Failed to initialize app',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    e.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Restart app
                      SystemNavigator.pop();
                    },
                    child: const Text('Restart App'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyOnboardingProvider()),
        ChangeNotifierProvider(create: (_) => AboutUsProvider()),
        ChangeNotifierProvider(create: (_) => RemindersProvider()),
      ],
      child: MaterialApp(
        title: 'HydraTime',
        debugShowCheckedModeBanner: false,
        theme: darkTheme,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.mRoutes,
      ),
    );
  }
}
