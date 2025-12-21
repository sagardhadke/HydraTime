import 'package:hive/hive.dart';
import 'package:hydra_time/core/constants/hive_type_ids.dart';

part 'theme_settings_model.g.dart';

@HiveType(typeId: HiveTypeIds.appSettings)
class ThemeSettingsModel extends HiveObject {
  @HiveField(0)
  String themeMode;

  @HiveField(1)
  bool useSystemTheme;

  @HiveField(2)
  DateTime? lastUpdated;

  ThemeSettingsModel({
    required this.themeMode,
    this.useSystemTheme = false,
    this.lastUpdated,
  });

  factory ThemeSettingsModel.initial() {
    return ThemeSettingsModel(
      themeMode: 'dark',
      useSystemTheme: false,
      lastUpdated: DateTime.now(),
    );
  }

  ThemeSettingsModel copyWith({
    String? themeMode,
    bool? useSystemTheme,
    DateTime? lastUpdated,
  }) {
    return ThemeSettingsModel(
      themeMode: themeMode ?? this.themeMode,
      useSystemTheme: useSystemTheme ?? this.useSystemTheme,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() => {
    'themeMode': themeMode,
    'useSystemTheme': useSystemTheme,
    'lastUpdated': lastUpdated?.toIso8601String(),
  };

  factory ThemeSettingsModel.fromJson(Map<String, dynamic> json) {
    return ThemeSettingsModel(
      themeMode: json['themeMode'] as String,
      useSystemTheme: json['useSystemTheme'] as bool,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : null,
    );
  }
}
