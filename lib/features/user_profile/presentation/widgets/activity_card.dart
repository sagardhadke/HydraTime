import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/app_colors.dart';

class ActivityCard extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final bool isSelected;

  const ActivityCard({
    super.key,
    required this.label,
    required this.description,
    required this.icon,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryColor.withOpacity(0.15)
            : (isDark ? AppColors.darkGrey40 : AppColors.lightCard),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? AppColors.primaryColor
              : (isDark ? AppColors.darkGrey20 : AppColors.lightGrey40),
          width: isSelected ? 2.5 : 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryColor.withOpacity(0.2)
                  : (isDark ? AppColors.darkGrey60 : AppColors.lightGrey10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: isSelected
                  ? AppColors.primaryColor
                  : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isSelected ? AppColors.primaryColor : null,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(description, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          if (isSelected)
            Icon(Icons.check_circle, color: AppColors.primaryColor, size: 24),
        ],
      ),
    );
  }
}
