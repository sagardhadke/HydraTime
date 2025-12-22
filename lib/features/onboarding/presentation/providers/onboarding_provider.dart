import 'package:flutter/material.dart';
import 'package:hydra_time/core/usecases/usecase.dart';
import 'package:hydra_time/features/onboarding/domain/entities/onboarding.dart';
import 'package:hydra_time/features/onboarding/domain/usecases/check_onboarding_status.dart';
import 'package:hydra_time/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:hydra_time/features/onboarding/domain/usecases/get_onboarding_pages.dart';
import 'package:hydra_time/features/onboarding/domain/usecases/update_current_page.dart';

class OnboardingProvider extends ChangeNotifier {
  final CheckOnboardingStatus checkOnboardingStatus;
  final CompleteOnboarding completeOnboarding;
  final GetOnboardingPages getOnboardingPages;
  final UpdateCurrentPage updateCurrentPage;

  OnboardingProvider({
    required this.checkOnboardingStatus,
    required this.completeOnboarding,
    required this.getOnboardingPages,
    required this.updateCurrentPage,
  });

  final PageController pageController = PageController();
  List<Onboarding> _pages = [];
  int _currentIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Onboarding> get pages => _pages;
  int get currentIndex => _currentIndex;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLastPage => _currentIndex == _pages.length - 1;
  int get totalPages => _pages.length;

  /// Initialize onboarding pages
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    final result = await getOnboardingPages(NoParams());

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (pages) {
        _pages = pages;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
    );
  }

  /// Check if onboarding is completed
  Future<bool> isOnboardingCompleted() async {
    final result = await checkOnboardingStatus(NoParams());
    return result.fold(
      (failure) => false,
      (isCompleted) => isCompleted,
    );
  }

  /// Go to next page
  void onNext() {
    if (_currentIndex < _pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Skip to last page
  void onSkip() {
    pageController.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  /// Update current page index
  void onPageChanged(int index) {
    _currentIndex = index;
    updateCurrentPage(UpdateCurrentPageParams(page: index));
    notifyListeners();
  }

  /// Complete onboarding and navigate
  Future<bool> onFinish() async {
    _isLoading = true;
    notifyListeners();

    final result = await completeOnboarding(NoParams());

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}