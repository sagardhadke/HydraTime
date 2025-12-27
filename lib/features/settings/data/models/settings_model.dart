import 'package:hive/hive.dart';
import 'package:hydra_time/core/constants/hive_type_ids.dart';
import 'package:hydra_time/features/settings/domain/entities/app_settings.dart';

part 'settings_model.g.dart';

@HiveType(typeId: HiveTypeIds.appSettings)
class SettingsModel extends AppSettings {
  const SettingsModel({
    required super.themeMode,
    required super.notificationsEnabled,
    required super.soundEnabled,
    required super.vibrationEnabled,
    required super.language,
    required super.dataBackupEnabled,
    super.lastBackupDate,
    required super.privacyPolicyAccepted,
    super.privacyAcceptedDate,
  });

  /// Factory constructor for initial settings
  factory SettingsModel.initial() {
    return const SettingsModel(
      themeMode: 'dark',
      notificationsEnabled: true,
      soundEnabled: true,
      vibrationEnabled: true,
      language: 'en',
      dataBackupEnabled: false,
      lastBackupDate: null,
      privacyPolicyAccepted: false,
      privacyAcceptedDate: null,
    );
  }

  /// Factory constructor from entity
  factory SettingsModel.fromEntity(AppSettings entity) {
    return SettingsModel(
      themeMode: entity.themeMode,
      notificationsEnabled: entity.notificationsEnabled,
      soundEnabled: entity.soundEnabled,
      vibrationEnabled: entity.vibrationEnabled,
      language: entity.language,
      dataBackupEnabled: entity.dataBackupEnabled,
      lastBackupDate: entity.lastBackupDate,
      privacyPolicyAccepted: entity.privacyPolicyAccepted,
      privacyAcceptedDate: entity.privacyAcceptedDate,
    );
  }

  /// Copy with method
  SettingsModel copyWith({
    String? themeMode,
    bool? notificationsEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
    String? language,
    bool? dataBackupEnabled,
    DateTime? lastBackupDate,
    bool? privacyPolicyAccepted,
    DateTime? privacyAcceptedDate,
  }) {
    return SettingsModel(
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      language: language ?? this.language,
      dataBackupEnabled: dataBackupEnabled ?? this.dataBackupEnabled,
      lastBackupDate: lastBackupDate ?? this.lastBackupDate,
      privacyPolicyAccepted:
          privacyPolicyAccepted ?? this.privacyPolicyAccepted,
      privacyAcceptedDate: privacyAcceptedDate ?? this.privacyAcceptedDate,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
    'themeMode': themeMode,
    'notificationsEnabled': notificationsEnabled,
    'soundEnabled': soundEnabled,
    'vibrationEnabled': vibrationEnabled,
    'language': language,
    'dataBackupEnabled': dataBackupEnabled,
    'lastBackupDate': lastBackupDate?.toIso8601String(),
    'privacyPolicyAccepted': privacyPolicyAccepted,
    'privacyAcceptedDate': privacyAcceptedDate?.toIso8601String(),
  };

  /// Factory constructor from JSON
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      themeMode: json['themeMode'] as String? ?? 'dark',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      language: json['language'] as String? ?? 'en',
      dataBackupEnabled: json['dataBackupEnabled'] as bool? ?? false,
      lastBackupDate: json['lastBackupDate'] != null
          ? DateTime.tryParse(json['lastBackupDate'] as String)
          : null,
      privacyPolicyAccepted: json['privacyPolicyAccepted'] as bool? ?? false,
      privacyAcceptedDate: json['privacyAcceptedDate'] != null
          ? DateTime.tryParse(json['privacyAcceptedDate'] as String)
          : null,
    );
  }
}
