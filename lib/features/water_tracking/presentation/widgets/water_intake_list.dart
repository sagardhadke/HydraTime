import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/core/extensions/extensions.dart';
import 'package:hydra_time/features/water_tracking/domain/entities/water_intake.dart';
import 'package:intl/intl.dart';

class WaterIntakeList extends StatelessWidget {
  final List<WaterIntake> intakes;
  final Function(String) onRemove;

  const WaterIntakeList({
    super.key,
    required this.intakes,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: intakes. length,
      itemBuilder: (context, index) {
        final intake = intakes[index];
        return Dismissible(
          key: Key(intake.id),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius. circular(12),
            ),
            alignment: Alignment.centerRight,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) => onRemove(intake.id),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkGrey40 : AppColors.lightGrey10,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? AppColors.darkGrey20
                    : AppColors.lightGrey40,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.opacity,
                    color: AppColors.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment. start,
                    children: [
                      Text(
                        '${intake.amount.toInt()} ml',
                        style: context.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            DateFormat('HH:mm').format(intake.timestamp),
                            style: context. textTheme.bodySmall,
                          ),
                          if (intake.notes != null) ...[
                            const Text(' • '),
                            Expanded(
                              child: Text(
                                intake.notes! ,
                                style: context.textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => onRemove(intake.id),
                  icon: const Icon(Icons.close),
                  iconSize: 20,
                  color: Colors.red,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}