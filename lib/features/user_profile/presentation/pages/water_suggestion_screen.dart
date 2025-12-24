import 'package:flutter/material.dart';
import 'package:hydra_time/Routes/app_routes.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/core/extensions/extensions.dart';
import 'package:hydra_time/features/user_profile/presentation/providers/user_profile_provider.dart';
import 'package:hydra_time/shared/animations/animations.dart';
import 'package:hydra_time/shared/widgets/shared_widgets.dart';
import 'package:provider/provider.dart';

class WaterSuggestionScreen extends StatefulWidget {
  const WaterSuggestionScreen({super.key});

  @override
  State<WaterSuggestionScreen> createState() => _WaterSuggestionScreenState();
}

class _WaterSuggestionScreenState extends State<WaterSuggestionScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Water Goal'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<UserProfileProvider>(
        builder: (context, provider, _) {
          final waterGoalLiters = provider.calculatedWaterGoal / 1000;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FadeInAnimation(
                  child: Text(
                    'Your Daily Water Goal',
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),

                FadeInAnimation(
                  delay: const Duration(milliseconds: 200),
                  child: Text(
                    'Based on your profile, we recommend: ',
                    style: context.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 48),

                ScaleAnimation(
                  delay: const Duration(milliseconds: 400),
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor.withOpacity(0.15),
                          AppColors.primaryColor.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.opacity,
                          size: 80,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${waterGoalLiters.toStringAsFixed(1)} L',
                          style: context.textTheme.displaySmall?.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${provider.calculatedWaterGoal.toStringAsFixed(0)} ml per day',
                          style: context.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                SlideInAnimation(
                  delay: const Duration(milliseconds: 600),
                  direction: SlideDirection.bottom,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkGrey20
                            : AppColors.lightGrey40,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Based on: ',
                          style: context.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          context,
                          'Weight',
                          '${provider.weight} kg',
                          Icons.scale,
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          context,
                          'Activity Level',
                          provider.activityLevel,
                          Icons.fitness_center,
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          context,
                          'Climate',
                          provider.climate,
                          Icons.wb_sunny,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                SlideInAnimation(
                  delay: const Duration(milliseconds: 800),
                  direction: SlideDirection.bottom,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.lightbulb_outline,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Adjust this goal anytime based on how you feel',
                            style: context.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                SlideInAnimation(
                  delay: const Duration(milliseconds: 1000),
                  direction: SlideDirection.bottom,
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: PrimaryButton(
                          text: 'Get Started',
                          isLoading: _isLoading,
                          onPressed: _isLoading
                              ? null
                              : () => _saveProfileAndNavigate(provider),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: SecondaryButton(
                          text: 'Adjust Goal',
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: AppColors.primaryColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              Text(value, style: context.textTheme.titleSmall),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _saveProfileAndNavigate(UserProfileProvider provider) async {
    setState(() => _isLoading = true);

    final success = await provider.saveUserProfile();

    if (mounted) {
      setState(() => _isLoading = false);

      if (success) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.dashBoard,
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? 'Failed to save profile'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
