import 'package:flutter/material.dart';
import 'package:hydra_time/Routes/app_routes.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/core/constants/prefs_keys.dart';
import 'package:hydra_time/core/services/shared_prefs_service.dart';
import 'package:hydra_time/provider/myOnBoarding_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MyOnBoardingScreen extends StatelessWidget {
  MyOnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyOnboardingProvider>(
      builder: (context, provider, child) {
        Future<void> getUserOnBoardDetails() async {
          final prefs = SharedPrefsService.instance;
          await prefs.setBool(PrefsKeys.onboardingComplete, true);
          debugPrint("User onBoarding Successfully");
          Navigator.pushReplacementNamed(context, AppRoutes.personalInfo);
        }

        void onNext() {
          if (provider.currentIndex < provider.pages.length - 1) {
            provider.pageController.nextPage(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          } else {
            getUserOnBoardDetails();
          }
        }

        void onSkip() {
          provider.pageController.animateToPage(
            provider.pages.length - 1,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }

        return Scaffold(
          body: Stack(
            children: [
              PageView.builder(
                controller: provider.pageController,
                itemCount: provider.pages.length,
                onPageChanged: (value) {
                  provider.onPageChanged(value);
                  // setState(() {
                  //   currentIndex = value;
                  // });
                },
                itemBuilder: (context, index) => provider.pages[index],
              ),
              provider.currentIndex == provider.pages.length - 1
                  ? SizedBox.shrink()
                  : Positioned(
                      bottom: 40,
                      left: 20,
                      child: TextButton(
                        onPressed: () => onSkip(),
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: Color(0XFFF6F6F6),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
              Positioned(
                bottom: 40,
                right: 20,
                child: TextButton(
                  onPressed: () => onNext(),
                  child: Text(
                    provider.currentIndex == provider.pages.length - 1
                        ? 'Finish'
                        : 'Next',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                left: 0,
                bottom: 45,
                child: Center(
                  child: SmoothPageIndicator(
                    controller: provider.pageController,
                    count: provider.pages.length,
                    effect: WormEffect(
                      dotHeight: 12,
                      dotWidth: 12,
                      dotColor: Colors.white,
                      activeDotColor: Color(0XFF00B8D4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
