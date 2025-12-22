import 'package:flutter/material.dart';
import 'package:hydra_time/Routes/app_routes.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:hydra_time/features/onboarding/presentation/widgets/onboarding_page_widget.dart';
import 'package:hydra_time/features/onboarding/presentation/widgets/page_indicator.dart';
import 'package:hydra_time/shared/widgets/feedback/snackbar_helper.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<OnboardingProvider>(
        builder: (context, provider, child) {
          // Show loading
          if (provider.isLoading && provider.pages.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Show error
          if (provider.errorMessage != null && provider.pages.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.errorColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load onboarding',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.errorMessage!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => provider.init(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Show onboarding pages
          return Stack(
            children: [
              // PageView
              PageView.builder(
                controller: provider.pageController,
                itemCount: provider.pages.length,
                onPageChanged: provider.onPageChanged,
                itemBuilder: (context, index) {
                  return OnboardingPageWidget(
                    onboarding: provider.pages[index],
                    index: index,
                  );
                },
              ),

              // Skip button (hide on last page)
              if (!provider.isLastPage)
                Positioned(
                  top: 48,
                  left: 20,
                  child: TextButton(
                    onPressed: provider.onSkip,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              // Bottom navigation
              Positioned(
                bottom: 48,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    // Page indicator
                    PageIndicator(
                      currentIndex: provider.currentIndex,
                      pageCount: provider.totalPages,
                    ),
                    const SizedBox(height: 32),

                    // Next/Finish button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: provider.isLoading
                              ? null
                              : () => _handleButtonPress(provider),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: provider.isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black,
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      provider.isLastPage
                                          ? 'Get Started'
                                          : 'Next',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.arrow_forward, size: 20),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _handleButtonPress(OnboardingProvider provider) async {
    if (provider.isLastPage) {
      // Finish onboarding
      final success = await provider.onFinish();
      if (success && mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.personalInfo);
      } else if (mounted) {
        SnackBarHelper.showError(
          context,
          provider.errorMessage ?? 'Failed to complete onboarding',
        );
      }
    } else {
      // Go to next page
      provider.onNext();
    }
  }
}