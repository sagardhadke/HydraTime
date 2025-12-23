import 'package:hydra_time/core/constants/hive_box_names.dart';
import 'package:hydra_time/core/errors/exceptions.dart';
import 'package:hydra_time/features/user_profile/data/models/user_profile_model.dart';
import 'package:hydra_time/services/storage/hive_service.dart';

abstract class UserProfileLocalDataSource {
  Future<UserProfileModel> getUserProfile();
  Future<void> saveUserProfile(UserProfileModel profile);
  Future<void> updateUserProfile(UserProfileModel profile);
  Future<void> deleteUserProfile();
  Future<bool> hasUserProfile();
}

class UserProfileLocalDataSourceImpl implements UserProfileLocalDataSource {
  final HiveService hiveService;

  UserProfileLocalDataSourceImpl({required this.hiveService});

  static const String _profileKey = 'user_profile';

  @override
  Future<UserProfileModel> getUserProfile() async {
    try {
      final box = hiveService.getBox(HiveBoxNames.userProfile);
      final data = box.get(_profileKey);

      if (data == null) {
        return UserProfileModel.initial();
      }

      if (data is Map) {
        return UserProfileModel.fromJson(Map<String, dynamic>.from(data));
      }

      return UserProfileModel.initial();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get user profile: $e',
        code: 'PROFILE_GET_ERROR',
      );
    }
  }

  @override
  Future<void> saveUserProfile(UserProfileModel profile) async {
    try {
      final box = hiveService.getBox(HiveBoxNames.userProfile);
      final profileWithTimestamp = profile.copyWith(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await box.put(_profileKey, profileWithTimestamp.toJson());
    } catch (e) {
      throw CacheException(
        message: 'Failed to save user profile: $e',
        code: 'PROFILE_SAVE_ERROR',
      );
    }
  }

  @override
  Future<void> updateUserProfile(UserProfileModel profile) async {
    try {
      final box = hiveService.getBox(HiveBoxNames.userProfile);
      final currentProfile = await getUserProfile();
      final updatedProfile = profile.copyWith(
        createdAt: currentProfile.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await box.put(_profileKey, updatedProfile.toJson());
    } catch (e) {
      throw CacheException(
        message: 'Failed to update user profile: $e',
        code: 'PROFILE_UPDATE_ERROR',
      );
    }
  }

  @override
  Future<void> deleteUserProfile() async {
    try {
      final box = hiveService.getBox(HiveBoxNames.userProfile);
      await box.delete(_profileKey);
    } catch (e) {
      throw CacheException(
        message: 'Failed to delete user profile: $e',
        code: 'PROFILE_DELETE_ERROR',
      );
    }
  }

  @override
  Future<bool> hasUserProfile() async {
    try {
      final profile = await getUserProfile();
      return profile.isComplete;
    } catch (e) {
      return false;
    }
  }
}