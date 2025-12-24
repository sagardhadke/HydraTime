import 'package:flutter/material.dart';
import 'package:hydra_time/Routes/app_routes.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/shared/animations/fade_in_animation.dart';
import 'package:hydra_time/shared/animations/slide_in_animation.dart';
import 'package:hydra_time/shared/widgets/buttons/primary_button.dart';
import 'package:hydra_time/shared/widgets/buttons/secondary_button.dart';
import 'package:provider/provider.dart';
import 'package:hydra_time/features/user_profile/user_profile_feature.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String _selectedActivity = '';

  final List<Map<String, dynamic>> activities = [
    {
      'label': 'Sedentary',
      'description': 'Little or no exercise',
      'icon': Icons.chair,
    },
    {
      'label': 'Low Active',
      'description': 'Light exercise 1-3 days/week',
      'icon': Icons.directions_walk,
    },
    {
      'label': 'Active',
      'description': 'Moderate exercise 3-5 days/week',
      'icon': Icons.directions_run,
    },
    {
      'label': 'Very Active',
      'description': 'Hard exercise 6-7 days/week',
      'icon': Icons.fitness_center,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activity Level'), centerTitle: true),
      body: Consumer<UserProfileProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInAnimation(
                  child: UserSetupHeader(
                    stepNumber: 3,
                    totalSteps: 6,
                    title: 'Your Activity Level',
                    subtitle:
                        'This helps us calculate your personalized water goal',
                  ),
                ),
                const SizedBox(height: 32),

                ...List.generate(
                  activities.length,
                  (index) => SlideInAnimation(
                    delay: Duration(milliseconds: 100 * (index + 1)),
                    direction: SlideDirection.bottom,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        onTap: () {
                          setState(
                            () =>
                                _selectedActivity = activities[index]['label'],
                          );
                          provider.setActivityLevel(activities[index]['label']);
                        },
                        child: ActivityCard(
                          label: activities[index]['label'],
                          description: activities[index]['description'],
                          icon: activities[index]['icon'],
                          isSelected:
                              _selectedActivity == activities[index]['label'],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                if (provider.errorMessage != null)
                  SlideInAnimation(
                    direction: SlideDirection.top,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.errorColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.errorColor),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppColors.errorColor,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              provider.errorMessage!,
                              style: const TextStyle(
                                color: AppColors.errorColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        text: 'Back',
                        icon: Icons.arrow_back,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PrimaryButton(
                        text: 'Next',
                        icon: Icons.arrow_forward,
                        onPressed: _selectedActivity.isNotEmpty
                            ? () => Navigator.pushNamed(
                                context,
                                AppRoutes.yourClimate,
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
