import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/core/extensions/extensions.dart';
import 'package:hydra_time/features/statistics/presentation/providers/statistics_provider.dart';
import 'package:hydra_time/features/statistics/presentation/widgets/achievement_card.dart';
import 'package:hydra_time/features/statistics/presentation/widgets/period_selector.dart';
import 'package:hydra_time/features/statistics/presentation/widgets/stats_card.dart';
import 'package:hydra_time/features/statistics/presentation/widgets/stats_chart_widget.dart';
import 'package:hydra_time/features/statistics/presentation/widgets/streak_widget.dart';
import 'package:hydra_time/shared/animations/animations.dart';
import 'package:hydra_time/shared/widgets/shared_widgets.dart' hide StatsCard;
import 'package:provider/provider.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StatisticsProvider>().initializeStatistics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        centerTitle: true,
        actions: [
          Consumer<StatisticsProvider>(
            builder: (context, provider, _) {
              return IconButton(
                onPressed: () => provider.refresh(),
                icon: const Icon(Icons.refresh),
              );
            },
          ),
        ],
      ),
      body: Consumer<StatisticsProvider>(
        builder: (context, provider, _) {
          // Show loading
          if (provider.isLoading && provider.dailyStats.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show error
          if (provider.errorMessage != null && provider.dailyStats.isEmpty) {
            return CustomErrorWidget(
              title: 'Failed to Load Statistics',
              message: provider.errorMessage,
              onRetry: () => provider.refresh(),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.refresh(),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Period Selector
                  FadeInAnimation(
                    child: PeriodSelector(
                      selectedPeriod: provider.selectedPeriod,
                      onPeriodChanged: provider.setPeriod,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Today's Stats Overview
                  if (provider.todayStats != null)
                    SlideInAnimation(
                      delay: const Duration(milliseconds: 100),
                      direction: SlideDirection.bottom,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: StatsCard(
                          title: "Today's Intake",
                          value:
                              '${provider.todayStats!.totalIntake.toStringAsFixed(0)} ml',
                          subtitle:
                              'Goal: ${provider.todayStats!.dailyGoal.toStringAsFixed(0)} ml',
                          icon: Icons.opacity,
                          iconColor: AppColors.primaryColor,
                        ),
                      ),
                    ),

                  const SizedBox(height: 12),

                  // Key Metrics Row
                  SlideInAnimation(
                    delay: const Duration(milliseconds: 200),
                    direction: SlideDirection.bottom,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: StatsCard(
                              title: 'Average',
                              value:
                                  '${provider.averageIntake.toStringAsFixed(0)} ml',
                              icon: Icons.show_chart,
                              iconColor: AppColors.successColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: StatsCard(
                              title: 'Goals Hit',
                              value: '${provider.goalsAchieved}/30',
                              icon: Icons.emoji_events,
                              iconColor: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Streak Widget
                  SlideInAnimation(
                    delay: const Duration(milliseconds: 300),
                    direction: SlideDirection.bottom,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: StreakWidget(streak: provider.streak.toInt()),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Charts Section
                  SlideInAnimation(
                    delay: const Duration(milliseconds: 400),
                    direction: SlideDirection.bottom,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Weekly Progress',
                            style: context.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          StatsChartWidget(
                            data: provider.weeklyStats,
                            chartType: 'bar',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Achievements Section
                  SlideInAnimation(
                    delay: const Duration(milliseconds: 500),
                    direction: SlideDirection.bottom,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Achievements',
                                style: context.textTheme.titleMedium,
                              ),
                              Text(
                                '${provider.unlockedAchievements.length}/${provider.achievements.length}',
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Achievement Progress Bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: (provider.achievementPercentage / 100)
                                  .clamp(0, 1),
                              minHeight: 8,
                              backgroundColor:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.darkGrey40
                                  : AppColors.lightGrey20,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Achievements Grid
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                            itemCount: provider.achievements.length,
                            itemBuilder: (context, index) {
                              final achievement = provider.achievements[index];
                              return ScaleAnimation(
                                delay: Duration(
                                  milliseconds: 600 + (index * 50),
                                ),
                                begin: 0.8,
                                child: AchievementCard(
                                  achievement: achievement,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
