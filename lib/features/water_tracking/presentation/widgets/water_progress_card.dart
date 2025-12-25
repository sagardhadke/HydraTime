import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/core/extensions/extensions.dart';

class WaterProgressCard extends StatelessWidget {
  final double totalIntake;
  final double dailyGoal;
  final double percentage;
  final int remainingMl;

  const WaterProgressCard({
    super.key,
    required this. totalIntake,
    required this.dailyGoal,
    required this.percentage,
    required this.remainingMl,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isGoalAchieved = percentage >= 100;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:  [
            AppColors.primaryColor. withOpacity(0.15),
            AppColors.primaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color:  AppColors.primaryColor.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Goal',
                    style: context.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${dailyGoal.toStringAsFixed(0)} ml',
                    style: context.textTheme.headlineSmall?. copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.opacity,
                  color: AppColors.primaryColor,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height:  24),

          // Circular Progress
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: (percentage / 100).clamp(0, 1),
                  strokeWidth: 12,
                  backgroundColor: isDark
                      ? AppColors.darkGrey40
                      : AppColors.lightGrey20,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isGoalAchieved
                        ? AppColors.successColor
                        : AppColors.primaryColor,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    '${percentage.toStringAsFixed(0)}%',
                    style: context.textTheme.displaySmall?. copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${totalIntake.toStringAsFixed(0)} ml',
                    style: context.textTheme.titleSmall,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height:  24),

          // Stats Row
          Row(
            children:  [
              Expanded(
                child: _buildStatItem(
                  context,
                  label: 'Consumed',
                  value: '${totalIntake.toStringAsFixed(0)} ml',
                  icon: Icons.check_circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  context,
                  label: 'Remaining',
                  value: '${remainingMl} ml',
                  icon: Icons.hourglass_empty,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding:  const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkGrey40 : AppColors.lightGrey10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: context.textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: context.textTheme.titleSmall?. copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}