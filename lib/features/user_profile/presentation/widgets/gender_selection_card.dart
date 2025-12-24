

import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/app_colors.dart';

class GenderSelectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;

  const GenderSelectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryColor. withOpacity(0.15)
            : (isDark ?  AppColors.darkGrey40 : AppColors.lightCard),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? AppColors.primaryColor
              : (isDark ? AppColors.darkGrey20 : AppColors.lightGrey40),
          width: isSelected ? 2.5 : 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
            color: isSelected
                ? AppColors.primaryColor
                : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isSelected ?  AppColors.primaryColor : null,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}