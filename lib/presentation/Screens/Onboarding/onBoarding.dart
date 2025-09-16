import 'package:flutter/material.dart';
import 'package:hydra_time/Routes/app_routes.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/core/constants/prefs_keys.dart';
import 'package:hydra_time/presentation/Screens/Onboarding/intro_component.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MyOnBoardingScreen extends StatefulWidget {
  const MyOnBoardingScreen({super.key});

  @override
  State<MyOnBoardingScreen> createState() => _MyOnBoardingScreenState();
}

class _MyOnBoardingScreenState extends State<MyOnBoardingScreen> {
  final List<Widget> _pages = [
    IntroComponent(
      title: "Track your water timing",
      description: "Staying hydrated can improve cognitive function.",
      imgPath: "assets/images/onBoard1.png",
    ),
    IntroComponent(
      title: "Your body needs water",
      description: "Set daily water intake goals and track their progress.",
      imgPath: "assets/images/onBoard2.png",
    ),
    IntroComponent(
      title: "Know how you hydrated",
      description:
          "We Provide personalised recommendations for how much water to drink based on the user's weight, age, and activity level.",
      imgPath: "assets/images/onBoard3.png",
    ),
  ];

  final PageController pageController = PageController();
  int currentIndex = 0;

  void onNext() {
    if (currentIndex < _pages.length - 1) {
      pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      getUserOnBoardDetails();
    }
  }

  Future<void> getUserOnBoardDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(PrefsKeys.onboardingComplete, true);
    debugPrint("User onBoarding Successfully");
    Navigator.pushReplacementNamed(context, AppRoutes.personalInfo);
  }

  void onSkip() {
    pageController.animateToPage(
      _pages.length - 1,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: _pages.length,
            onPageChanged: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            itemBuilder: (context, index) => _pages[index],
          ),
          currentIndex == _pages.length - 1
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
                currentIndex == _pages.length - 1 ? 'Finish' : 'Next',
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
                controller: pageController,
                count: _pages.length,
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
  }
}
