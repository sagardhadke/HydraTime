import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/features/statistics/presentation/providers/statistics_provider.dart';

class PeriodSelector extends StatelessWidget {
  final StatsPeriod selectedPeriod;
  final Function(StatsPeriod) onPeriodChanged;

  const PeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildPeriodButton(
            label: 'Daily',
            period: StatsPeriod.daily,
            isSelected: selectedPeriod == StatsPeriod.daily,
            onTap: () => onPeriodChanged(StatsPeriod.daily),
          ),
          const SizedBox(width: 8),
          _buildPeriodButton(
            label: 'Weekly',
            period: StatsPeriod.weekly,
            isSelected: selectedPeriod == StatsPeriod.weekly,
            onTap: () => onPeriodChanged(StatsPeriod.weekly),
          ),
          const SizedBox(width: 8),
          _buildPeriodButton(
            label: 'Monthly',
            period: StatsPeriod.monthly,
            isSelected: selectedPeriod == StatsPeriod.monthly,
            onTap: () => onPeriodChanged(StatsPeriod.monthly),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodButton({
    required String label,
    required StatsPeriod period,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryColor
                  : AppColors.primaryColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? Colors.black : AppColors.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
