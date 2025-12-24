import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/app_colors.dart';

class ClimateCard extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final String emoji;
  final bool isSelected;

  const ClimateCard({
    super.key,
    required this.label,
    required this.description,
    required this.icon,
    required this.emoji,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isSelected ? AppColors.primaryColor : null,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontSize: 11),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
