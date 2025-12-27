import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hydra_time/Routes/app_routes.dart';
import 'package:hydra_time/config/dependency_injection/injection_container.dart';
import 'package:hydra_time/core/services/notification_service.dart';
import 'package:hydra_time/core/theme/theme_provider.dart';
import 'package:hydra_time/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:hydra_time/features/settings/presentation/providers/settings_provider.dart';
import 'package:hydra_time/features/statistics/presentation/providers/statistics_provider.dart';
import 'package:hydra_time/features/user_profile/presentation/providers/user_profile_provider.dart';
import 'package:hydra_time/features/water_tracking/presentation/providers/water_tracking_provider.dart';
import 'package:hydra_time/provider/about_us_provider.dart';
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

    final themeProvider = sl<ThemeProvider>();
    await themeProvider.initTheme();
    debugPrint('✅ Theme initialized');

    final notificationService = sl<NotificationService>();
    await notificationService.initNotification();
    debugPrint('✅ Notifications initialized');

    runApp(MyApp(themeProvider: themeProvider));
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

class MyApp extends StatefulWidget {
  final ThemeProvider themeProvider;
  const MyApp({super.key, required this.themeProvider});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    final brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    widget.themeProvider.updateSystemTheme(brightness);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: widget.themeProvider),
        ChangeNotifierProvider(create: (_) => sl<OnboardingProvider>()),
        ChangeNotifierProvider(create: (_) => sl<UserProfileProvider>()),
        ChangeNotifierProvider(create: (_) => sl<WaterTrackingProvider>()),
        ChangeNotifierProvider(create: (_) => sl<StatisticsProvider>()),
        ChangeNotifierProvider(create: (_) => sl<SettingsProvider>()),
        ChangeNotifierProvider(create: (_) => AboutUsProvider()),
        ChangeNotifierProvider(create: (_) => RemindersProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: themeProvider.isDarkMode
                  ? Brightness.light
                  : Brightness.dark,
              systemNavigationBarColor: themeProvider.isDarkMode
                  ? Colors.black
                  : Colors.white,
              systemNavigationBarIconBrightness: themeProvider.isDarkMode
                  ? Brightness.light
                  : Brightness.dark,
            ),
          );

          return MaterialApp(
            title: 'HydraTime',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeData,
            initialRoute: AppRoutes.splash,
            routes: AppRoutes.mRoutes,
          );
        },
      ),
    );
  }
}
