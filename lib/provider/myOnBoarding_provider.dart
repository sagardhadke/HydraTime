import 'package:flutter/material.dart';
import 'package:hydra_time/presentation/Screens/Onboarding/intro_component.dart';

class MyOnboardingProvider extends ChangeNotifier {
  final List<Widget> pages = [
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

  void onPageChanged(int index) {
    currentIndex = index;
    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
