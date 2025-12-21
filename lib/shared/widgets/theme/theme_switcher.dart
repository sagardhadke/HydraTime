import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/core/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeSwitcher extends StatelessWidget {
  final bool showLabel;
  final bool compact;

  const ThemeSwitcher({
    super.key,
    this.showLabel = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        if (compact) {
          return _buildCompactSwitcher(context, themeProvider);
        }
        return _buildFullSwitcher(context, themeProvider);
      },
    );
  }

  Widget _buildFullSwitcher(BuildContext context, ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeProvider.isDarkMode
              ? AppColors.darkGrey20
              : AppColors.lightGrey40,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                themeProvider.themeIcon,
                color: AppColors.primaryColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Theme',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      themeProvider.themeModeDisplayName,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => themeProvider.toggleTheme(),
                icon: Icon(
                  themeProvider.isDarkMode
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                tooltip: 'Toggle theme',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildThemeOptions(context, themeProvider),
        ],
      ),
    );
  }

  Widget _buildCompactSwitcher(
      BuildContext context, ThemeProvider themeProvider) {
    return IconButton(
      onPressed: () => themeProvider.toggleTheme(),
      icon: Icon(themeProvider.themeIcon),
      tooltip: 'Toggle theme',
    );
  }

  Widget _buildThemeOptions(
      BuildContext context, ThemeProvider themeProvider) {
    return Row(
      children: [
        Expanded(
          child: _buildThemeOption(
            context: context,
            label: 'Light',
            icon: Icons.light_mode,
            isSelected: themeProvider.themeMode == AppThemeMode.light &&
                !themeProvider.useSystemTheme,
            onTap: () => themeProvider.setThemeMode(AppThemeMode.light),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildThemeOption(
            context: context,
            label: 'Dark',
            icon: Icons.dark_mode,
            isSelected: themeProvider.themeMode == AppThemeMode.dark &&
                !themeProvider.useSystemTheme,
            onTap: () => themeProvider.setThemeMode(AppThemeMode.dark),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildThemeOption(
            context: context,
            label: 'System',
            icon: Icons.brightness_auto,
            isSelected: themeProvider.useSystemTheme,
            onTap: () => themeProvider.setThemeMode(AppThemeMode.system),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withOpacity(0.15)
              : (isDark ? AppColors.darkGrey40 : AppColors.lightGrey20),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : (isDark ? AppColors.darkGrey20 : AppColors.lightGrey40),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? AppColors.primaryColor
                  : (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isSelected
                        ? AppColors.primaryColor
                        : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}