import 'package:flutter/material.dart';
import 'package:hydra_time/Routes/app_routes.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/features/user_profile/presentation/providers/user_profile_provider.dart';
import 'package:hydra_time/shared/animations/animations.dart';
import 'package:provider/provider.dart';

class PreparingPlanScreen extends StatefulWidget {
  const PreparingPlanScreen({super.key});

  @override
  State<PreparingPlanScreen> createState() => _PreparingPlanScreenState();
}

class _PreparingPlanScreenState extends State<PreparingPlanScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _animationController.repeat();

    _navigateToWaterSuggestion();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToWaterSuggestion() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.waterSuggestion);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserProfileProvider>(
        builder: (context, provider, _) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryColor.withOpacity(0.1),
                  AppColors.primaryColor.withOpacity(0.05),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleAnimation(
                    duration: const Duration(seconds: 2),
                    begin: 0.8,
                    end: 1.2,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: RotationTransition(
                          turns: Tween(
                            begin: 0.0,
                            end: 1.0,
                          ).animate(_animationController),
                          child: const Icon(
                            Icons.opacity,
                            size: 60,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  FadeInAnimation(
                    delay: const Duration(milliseconds: 500),
                    child: Text(
                      'Preparing Your\nPersonalized Plan',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),

                  FadeInAnimation(
                    delay: const Duration(milliseconds: 700),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'We\'re calculating your personalized water intake goal based on your profile',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  FadeInAnimation(
                    delay: const Duration(milliseconds: 900),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => ScaleAnimation(
                          duration: const Duration(milliseconds: 600),
                          delay: Duration(milliseconds: 200 * index),
                          child: Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
