import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final String themeMode; // 'light', 'dark', 'system'
  final bool notificationsEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final String language; // 'en', 'es', 'fr', etc.
  final bool dataBackupEnabled;
  final DateTime? lastBackupDate;
  final bool privacyPolicyAccepted;
  final DateTime? privacyAcceptedDate;

  const AppSettings({
    required this.themeMode,
    required this.notificationsEnabled,
    required this.soundEnabled,
    required this.vibrationEnabled,
    required this.language,
    required this.dataBackupEnabled,
    this.lastBackupDate,
    required this.privacyPolicyAccepted,
    this.privacyAcceptedDate,
  });

  factory AppSettings.initial() {
    return const AppSettings(
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

  AppSettings copyWith({
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
    return AppSettings(
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

  @override
  List<Object?> get props => [
    themeMode,
    notificationsEnabled,
    soundEnabled,
    vibrationEnabled,
    language,
    dataBackupEnabled,
    lastBackupDate,
    privacyPolicyAccepted,
    privacyAcceptedDate,
  ];
}
