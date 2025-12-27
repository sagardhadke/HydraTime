import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/app_colors.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Color? titleColor;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color:
                  titleColor ??
                  (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkGrey60 : AppColors.lightCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.darkGrey20 : AppColors.lightGrey40,
              width: 1,
            ),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}
