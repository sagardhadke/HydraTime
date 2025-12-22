import 'package:flutter/material.dart';
import 'package:hydra_time/features/onboarding/domain/entities/onboarding.dart';
import 'package:hydra_time/shared/animations/animations.dart';

class OnboardingPageWidget extends StatelessWidget {
  final Onboarding onboarding;
  final int index;

  const OnboardingPageWidget({
    super.key,
    required this.onboarding,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Image with animation
              FadeInAnimation(
                delay: Duration(milliseconds: 200 * index),
                child: ScaleAnimation(
                  delay: Duration(milliseconds: 300 * index),
                  child: Image.asset(
                    onboarding.imagePath,
                    height: 350,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              // Title with animation
              SlideInAnimation(
                delay: Duration(milliseconds: 400 * index),
                direction: SlideDirection.bottom,
                child: Text(
                  onboarding.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              // Description with animation
              SlideInAnimation(
                delay: Duration(milliseconds: 500 * index),
                direction: SlideDirection.bottom,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    onboarding.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
