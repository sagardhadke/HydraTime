import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/core/extensions/extensions.dart';
import 'package:hydra_time/core/theme/theme_provider.dart';
import 'package:hydra_time/features/settings/presentation/providers/settings_provider.dart';
import 'package:hydra_time/features/settings/presentation/widgets/settings_section.dart';
import 'package:hydra_time/features/settings/presentation/widgets/settings_tile.dart';
import 'package:hydra_time/shared/animations/animations.dart';
import 'package:hydra_time/shared/widgets/shared_widgets.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsProvider>().initializeSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: Consumer<SettingsProvider>(
        builder: (context, provider, _) {
          // Show loading
          if (provider.isLoading && provider.settings == null) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show error
          if (provider.errorMessage != null && provider.settings == null) {
            return CustomErrorWidget(
              title: 'Failed to Load Settings',
              message: provider.errorMessage,
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Theme Settings Section
                FadeInAnimation(
                  child: SettingsSection(
                    title: 'Appearance',
                    children: [
                      SlideInAnimation(
                        delay: const Duration(milliseconds: 100),
                        direction: SlideDirection.bottom,
                        child: SettingsTile(
                          title: 'Theme',
                          subtitle: 'Light, Dark, or System',
                          trailing: _buildThemeSelector(),
                          onTap: null,
                        ),
                      ),
                    ],
                  ),
                ),

                // Notification Settings Section
                SlideInAnimation(
                  delay: const Duration(milliseconds: 200),
                  direction: SlideDirection.bottom,
                  child: SettingsSection(
                    title: 'Notifications',
                    children: [
                      SettingsTile(
                        title: 'Enable Notifications',
                        subtitle: 'Get water reminder notifications',
                        trailing: Switch(
                          value: provider.notificationsEnabled,
                          onChanged: (value) {
                            provider.toggleNotifications(value);
                          },
                        ),
                      ),
                      SettingsTile(
                        title: 'Sound',
                        subtitle: 'Play sound with notifications',
                        trailing: Switch(
                          value: provider.soundEnabled,
                          onChanged: (value) {
                            provider.toggleSound(value);
                          },
                        ),
                      ),
                      SettingsTile(
                        title: 'Vibration',
                        subtitle: 'Vibrate on notifications',
                        trailing: Switch(
                          value: provider.vibrationEnabled,
                          onChanged: (value) {
                            provider.toggleVibration(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Data Settings Section
                SlideInAnimation(
                  delay: const Duration(milliseconds: 300),
                  direction: SlideDirection.bottom,
                  child: SettingsSection(
                    title: 'Data & Privacy',
                    children: [
                      SettingsTile(
                        title: 'Auto Backup',
                        subtitle: 'Automatically backup your data',
                        trailing: Switch(
                          value: provider.dataBackupEnabled,
                          onChanged: (value) {
                            provider.toggleDataBackup(value);
                          },
                        ),
                      ),
                      if (provider.settings?.lastBackupDate != null)
                        SettingsTile(
                          title: 'Last Backup',
                          subtitle:
                              '${provider.settings!.lastBackupDate!.toFormattedDateTime}',
                          trailing: null,
                        ),
                      SettingsTile(
                        title: 'Export Data',
                        subtitle: 'Export all your data as JSON',
                        trailing: const Icon(Icons.file_download),
                        onTap: () => _showExportDialog(),
                      ),
                      SettingsTile(
                        title: 'Privacy Policy',
                        subtitle: 'View our privacy policy',
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _showPrivacyPolicy(),
                      ),
                    ],
                  ),
                ),

                // Danger Zone Section
                SlideInAnimation(
                  delay: const Duration(milliseconds: 400),
                  direction: SlideDirection.bottom,
                  child: SettingsSection(
                    title: 'Danger Zone',
                    titleColor: Colors.red[400],
                    children: [
                      SettingsTile(
                        title: 'Clear All Data',
                        subtitle: 'Permanently delete all app data',
                        titleColor: Colors.red[400],
                        trailing: Icon(Icons.delete, color: Colors.red[400]),
                        onTap: () => _showClearDataDialog(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // App Info
                SlideInAnimation(
                  delay: const Duration(milliseconds: 500),
                  direction: SlideDirection.bottom,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'HydraTime v2.0.0',
                            style: context.textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Stay hydrated, stay healthy',
                            style: context.textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildThemeSelector() {
    return Consumer2<SettingsProvider, ThemeProvider>(
      builder: (context, settingsProvider, themeProvider, _) {
        return PopupMenuButton<String>(
          onSelected: (value) async {
            await themeProvider.setThemeMode(
              value == 'light'
                  ? AppThemeMode.light
                  : value == 'dark'
                  ? AppThemeMode.dark
                  : AppThemeMode.system,
            );
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(
              value: 'light',
              child: Row(
                children: [
                  Icon(Icons.light_mode, color: Colors.amber),
                  SizedBox(width: 12),
                  Text('Light'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'dark',
              child: Row(
                children: [
                  Icon(Icons.dark_mode, color: Colors.blue),
                  SizedBox(width: 12),
                  Text('Dark'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'system',
              child: Row(
                children: [
                  Icon(Icons.brightness_auto, color: Colors.grey),
                  SizedBox(width: 12),
                  Text('System'),
                ],
              ),
            ),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  size: 18,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  themeProvider.themeModeDisplayName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text('Export all your data as JSON file? '),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await context
                  .read<SettingsProvider>()
                  .exportData();
              if (success && mounted) {
                SnackBarHelper.showSuccess(
                  context,
                  'Data exported successfully! ',
                );
              }
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Privacy Policy', style: context.textTheme.titleLarge),
                const SizedBox(height: 20),
                _buildPrivacySection(
                  'Data Collection',
                  'HydraTime collects water intake data locally on your device.  No data is sent to external servers.',
                ),
                _buildPrivacySection(
                  'Data Storage',
                  'All your data is stored locally using encrypted Hive database. You have full control over your data.',
                ),
                _buildPrivacySection(
                  'Data Deletion',
                  'You can delete all your data at any time using the "Clear All Data" option in settings.',
                ),
                _buildPrivacySection(
                  'Third-Party Services',
                  'We do not share your data with any third-party services.',
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value:
                          context
                              .watch<SettingsProvider>()
                              .settings
                              ?.privacyPolicyAccepted ??
                          false,
                      onChanged: (value) {
                        if (value == true) {
                          context
                              .read<SettingsProvider>()
                              .acceptPrivacyPolicy();
                        }
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'I understand and accept the privacy policy',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacySection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(fontSize: 12, height: 1.5)),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your data including water intake history, reminders, and achievements.  This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await context
                  .read<SettingsProvider>()
                  .clearAllData();
              if (success && mounted) {
                SnackBarHelper.showSuccess(
                  context,
                  'All data cleared successfully',
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }
}
