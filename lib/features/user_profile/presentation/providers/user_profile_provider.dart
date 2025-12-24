import 'package:flutter/material.dart';
import 'package:hydra_time/core/usecases/usecase.dart';
import 'package:hydra_time/features/user_profile/domain/entities/user_profile.dart';
import 'package:hydra_time/features/user_profile/domain/usecases/calculate_water_goal.dart';
import 'package:hydra_time/features/user_profile/domain/usecases/get_user_profile.dart';
import 'package:hydra_time/features/user_profile/domain/usecases/save_user_profile.dart';
import 'package:hydra_time/features/user_profile/domain/usecases/update_user_profile.dart';

class UserProfileProvider extends ChangeNotifier {
  final GetUserProfile getUserProfileUseCase;
  final SaveUserProfile saveUserProfileUseCase;
  final UpdateUserProfile updateUserProfileUseCase;
  final CalculateWaterGoal calculateWaterGoalUseCase;

  UserProfileProvider({
    required this.getUserProfileUseCase,
    required this.saveUserProfileUseCase,
    required this.updateUserProfileUseCase,
    required this.calculateWaterGoalUseCase,
  });

  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;
  double _calculatedWaterGoal = 0.0;

  String _fullName = '';
  String _dateOfBirth = '';
  String _gender = '';
  String _wakeUpTime = '';
  String _bedTime = '';
  String _height = '';
  String _weight = '';
  String _activityLevel = '';
  String _climate = '';

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get calculatedWaterGoal => _calculatedWaterGoal;

  String get fullName => _fullName;
  String get dateOfBirth => _dateOfBirth;
  String get gender => _gender;
  String get wakeUpTime => _wakeUpTime;
  String get bedTime => _bedTime;
  String get height => _height;
  String get weight => _weight;
  String get activityLevel => _activityLevel;
  String get climate => _climate;

  bool get isProfileComplete => _userProfile?.isComplete ?? false;

  Future<void> loadUserProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getUserProfileUseCase(NoParams());

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (profile) {
        _userProfile = profile;
        _fullName = profile.fullName;
        _dateOfBirth = profile.dateOfBirth;
        _gender = profile.gender;
        _wakeUpTime = profile.wakeUpTime;
        _bedTime = profile.bedTime;
        _height = profile.height;
        _weight = profile.weight;
        _activityLevel = profile.activityLevel;
        _climate = profile.climate;
        _calculatedWaterGoal = profile.dailyWaterGoal;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
    );
  }

  void setFullName(String value) {
    _fullName = value;
    notifyListeners();
  }

  void setDateOfBirth(String value) {
    _dateOfBirth = value;
    notifyListeners();
  }

  void setGender(String value) {
    _gender = value;
    notifyListeners();
  }

  void setWakeUpTime(String value) {
    _wakeUpTime = value;
    notifyListeners();
  }

  void setBedTime(String value) {
    _bedTime = value;
    notifyListeners();
  }

  void setHeight(String value) {
    _height = value;
    notifyListeners();
  }

  void setWeight(String value) {
    _weight = value;
    notifyListeners();
  }

  void setActivityLevel(String value) {
    _activityLevel = value;
    notifyListeners();
  }

  void setClimate(String value) {
    _climate = value;
    notifyListeners();
  }

  Future<void> calculateWaterGoal() async {
    if (_weight.isEmpty || _activityLevel.isEmpty || _climate.isEmpty) {
      _errorMessage = 'Please fill in all required fields';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final weightDouble = double.tryParse(_weight) ?? 0.0;

    final result = await calculateWaterGoalUseCase(
      CalculateWaterGoalParams(
        weight: weightDouble,
        activityLevel: _activityLevel,
        climate: _climate,
      ),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (goal) {
        _calculatedWaterGoal = goal;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
    );
  }

  Future<bool> saveUserProfile() async {
    if (_fullName.isEmpty ||
        _dateOfBirth.isEmpty ||
        _gender.isEmpty ||
        _wakeUpTime.isEmpty ||
        _bedTime.isEmpty ||
        _height.isEmpty ||
        _weight.isEmpty ||
        _activityLevel.isEmpty ||
        _climate.isEmpty ||
        _calculatedWaterGoal <= 0) {
      _errorMessage = 'Please complete all fields';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final profile = UserProfile(
      fullName: _fullName,
      dateOfBirth: _dateOfBirth,
      gender: _gender,
      wakeUpTime: _wakeUpTime,
      bedTime: _bedTime,
      height: _height,
      weight: _weight,
      activityLevel: _activityLevel,
      climate: _climate,
      dailyWaterGoal: _calculatedWaterGoal,
    );

    final result = await saveUserProfileUseCase(
      SaveUserProfileParams(profile: profile),
    );

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        _userProfile = profile;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> updateUserProfile() async {
    if (_userProfile == null) {
      _errorMessage = 'No profile to update';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final updatedProfile = UserProfile(
      fullName: _fullName,
      dateOfBirth: _dateOfBirth,
      gender: _gender,
      wakeUpTime: _wakeUpTime,
      bedTime: _bedTime,
      height: _height,
      weight: _weight,
      activityLevel: _activityLevel,
      climate: _climate,
      dailyWaterGoal: _calculatedWaterGoal,
    );

    final result = await updateUserProfileUseCase(
      UpdateUserProfileParams(profile: updatedProfile),
    );

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        _userProfile = updatedProfile;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
        return true;
      },
    );
  }

  void resetForm() {
    _fullName = '';
    _dateOfBirth = '';
    _gender = '';
    _wakeUpTime = '';
    _bedTime = '';
    _height = '';
    _weight = '';
    _activityLevel = '';
    _climate = '';
    _calculatedWaterGoal = 0.0;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
