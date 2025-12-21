import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hydra_time/core/constants/hive_box_names.dart';
import 'package:hydra_time/core/theme/dark_theme.dart';
import 'package:hydra_time/core/theme/light_theme.dart';
import 'package:hydra_time/core/theme/models/theme_settings_model.dart';
import 'package:hydra_time/services/storage/hive_service.dart';

enum AppThemeMode { light, dark, system }

class ThemeProvider extends ChangeNotifier {
  final HiveService _hiveService = HiveService();

  ThemeData _themeData = darkTheme;
  AppThemeMode _themeMode = AppThemeMode.dark;
  bool _useSystemTheme = false;
  bool _isInitialized = false;

  ThemeData get themeData => _themeData;
  AppThemeMode get themeMode => _themeMode;
  bool get useSystemTheme => _useSystemTheme;
  bool get isInitialized => _isInitialized;
  bool get isDarkMode => _themeData.brightness == Brightness.dark;
  bool get isLightMode => _themeData.brightness == Brightness.light;

  Future<void> initTheme() async {
    if (_isInitialized) return;

    try {
      final settings = await _loadThemeSettings();

      if (settings.useSystemTheme) {
        _useSystemTheme = true;
        _applySystemTheme();
      } else {
        _useSystemTheme = false;
        _themeMode = _getThemeModeFromString(settings.themeMode);
        _themeData = _getThemeDataFromMode(_themeMode);
      }

      _isInitialized = true;
      notifyListeners();
      debugPrint('✅ Theme initialized: ${_themeMode.name}');
    } catch (e) {
      debugPrint('❌ Failed to initialize theme: $e');

      _themeData = darkTheme;
      _themeMode = AppThemeMode.dark;
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<ThemeSettingsModel> _loadThemeSettings() async {
    try {
      final settingsBox = _hiveService.getBox(HiveBoxNames.settings);
      final settings = settingsBox.get('theme_settings');

      if (settings != null && settings is Map) {
        return ThemeSettingsModel.fromJson(Map<String, dynamic>.from(settings));
      }

      return ThemeSettingsModel.initial();
    } catch (e) {
      debugPrint('❌ Failed to load theme settings: $e');
      return ThemeSettingsModel.initial();
    }
  }

  Future<void> _saveThemeSettings() async {
    try {
      final settingsBox = _hiveService.getBox(HiveBoxNames.settings);

      final settings = ThemeSettingsModel(
        themeMode: _themeMode.name,
        useSystemTheme: _useSystemTheme,
        lastUpdated: DateTime.now(),
      );

      await settingsBox.put('theme_settings', settings.toJson());
      debugPrint('✅ Theme settings saved');
    } catch (e) {
      debugPrint('❌ Failed to save theme settings: $e');
    }
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    if (_themeMode == mode && !_useSystemTheme) return;

    _themeMode = mode;
    _useSystemTheme = false;

    if (mode == AppThemeMode.system) {
      _useSystemTheme = true;
      _applySystemTheme();
    } else {
      _themeData = _getThemeDataFromMode(mode);
    }

    await _saveThemeSettings();
    notifyListeners();
    debugPrint('✅ Theme mode changed to: ${mode.name}');
  }

  Future<void> toggleTheme() async {
    if (_useSystemTheme) {
      final newMode = isDarkMode ? AppThemeMode.light : AppThemeMode.dark;
      await setThemeMode(newMode);
    } else {
      final newMode = isDarkMode ? AppThemeMode.light : AppThemeMode.dark;
      await setThemeMode(newMode);
    }
  }

  Future<void> enableSystemTheme() async {
    if (_useSystemTheme) return;

    _useSystemTheme = true;
    _themeMode = AppThemeMode.system;
    _applySystemTheme();

    await _saveThemeSettings();
    notifyListeners();
    debugPrint('✅ System theme enabled');
  }

  Future<void> disableSystemTheme() async {
    if (!_useSystemTheme) return;

    _useSystemTheme = false;

    _themeMode = isDarkMode ? AppThemeMode.dark : AppThemeMode.light;

    await _saveThemeSettings();
    notifyListeners();
    debugPrint('✅ System theme disabled');
  }

  void _applySystemTheme() {
    final brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    _themeData = brightness == Brightness.dark ? darkTheme : lightTheme;
    debugPrint('✅ System theme applied: ${brightness.name}');
  }

  ThemeData _getThemeDataFromMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return lightTheme;
      case AppThemeMode.dark:
        return darkTheme;
      case AppThemeMode.system:
        return _getSystemThemeData();
    }
  }

  ThemeData _getSystemThemeData() {
    final brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark ? darkTheme : lightTheme;
  }

  AppThemeMode _getThemeModeFromString(String mode) {
    switch (mode.toLowerCase()) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      case 'system':
        return AppThemeMode.system;
      default:
        return AppThemeMode.dark;
    }
  }

  void updateSystemTheme(Brightness brightness) {
    if (!_useSystemTheme) return;

    _themeData = brightness == Brightness.dark ? darkTheme : lightTheme;
    notifyListeners();
    debugPrint('✅ System theme updated: ${brightness.name}');
  }

  String get themeModeDisplayName {
    if (_useSystemTheme) return 'System';
    return _themeMode == AppThemeMode.light ? 'Light' : 'Dark';
  }

  IconData get themeIcon {
    if (_useSystemTheme) return Icons.brightness_auto;
    return isDarkMode ? Icons.dark_mode : Icons.light_mode;
  }
}
