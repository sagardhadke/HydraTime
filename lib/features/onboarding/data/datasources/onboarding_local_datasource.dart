import 'package:hydra_time/core/constants/hive_box_names.dart';
import 'package:hydra_time/core/errors/exceptions.dart';
import 'package:hydra_time/features/onboarding/data/models/onboarding_model.dart';
import 'package:hydra_time/services/storage/hive_service.dart';

abstract class OnboardingLocalDataSource {
  Future<OnboardingModel> getOnboardingStatus();
  Future<void> saveOnboardingStatus(OnboardingModel model);
  Future<void> completeOnboarding();
  Future<void> updateCurrentPage(int page);
  Future<void> resetOnboarding();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final HiveService hiveService;

  OnboardingLocalDataSourceImpl({required this.hiveService});

  static const String _onboardingKey = 'onboarding_status';

  @override
  Future<OnboardingModel> getOnboardingStatus() async {
    try {
      final box = hiveService.getBox(HiveBoxNames.onboarding);
      final data = box.get(_onboardingKey);

      if (data == null) {
        return OnboardingModel.initial();
      }

      if (data is Map) {
        return OnboardingModel.fromJson(Map<String, dynamic>.from(data));
      }

      return OnboardingModel.initial();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get onboarding status: $e',
        code: 'ONBOARDING_GET_ERROR',
      );
    }
  }

  @override
  Future<void> saveOnboardingStatus(OnboardingModel model) async {
    try {
      final box = hiveService.getBox(HiveBoxNames.onboarding);
      await box.put(_onboardingKey, model.toJson());
    } catch (e) {
      throw CacheException(
        message: 'Failed to save onboarding status: $e',
        code: 'ONBOARDING_SAVE_ERROR',
      );
    }
  }

  @override
  Future<void> completeOnboarding() async {
    try {
      final box = hiveService.getBox(HiveBoxNames.onboarding);
      final model = OnboardingModel(
        isCompleted: true,
        completedAt: DateTime.now(),
        currentPage: 0,
      );
      await box.put(_onboardingKey, model.toJson());
    } catch (e) {
      throw CacheException(
        message: 'Failed to complete onboarding: $e',
        code: 'ONBOARDING_COMPLETE_ERROR',
      );
    }
  }

  @override
  Future<void> updateCurrentPage(int page) async {
    try {
      final currentStatus = await getOnboardingStatus();
      final updatedStatus = currentStatus.copyWith(currentPage: page);
      await saveOnboardingStatus(updatedStatus);
    } catch (e) {
      throw CacheException(
        message: 'Failed to update current page: $e',
        code: 'ONBOARDING_UPDATE_ERROR',
      );
    }
  }

  @override
  Future<void> resetOnboarding() async {
    try {
      final box = hiveService.getBox(HiveBoxNames.onboarding);
      await box.delete(_onboardingKey);
    } catch (e) {
      throw CacheException(
        message: 'Failed to reset onboarding: $e',
        code: 'ONBOARDING_RESET_ERROR',
      );
    }
  }
}