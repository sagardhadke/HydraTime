import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static final SharedPrefsService _instance = SharedPrefsService._internal();
  static SharedPrefsService get instance => _instance;

  SharedPreferences? _prefs;

  SharedPrefsService._internal();

  /// * Initialize shared preferences before using
  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      if (kDebugMode) {
        print("SharedPrefs initialization failed: $e");
      }
    }
  }

  bool get isInitialized => _prefs != null;

  /// * Safe Getters
  String getString(String key, {String defaultValue = ''}) =>
      _prefs?.getString(key) ?? defaultValue;

  int getInt(String key, {int defaultValue = 0}) =>
      _prefs?.getInt(key) ?? defaultValue;

  double getDouble(String key, {double defaultValue = 0.0}) =>
      _prefs?.getDouble(key) ?? defaultValue;

  bool getBool(String key, {bool defaultValue = false}) =>
      _prefs?.getBool(key) ?? defaultValue;

  List<String> getStringList(
    String key, {
    List<String> defaultValue = const [],
  }) => _prefs?.getStringList(key) ?? defaultValue;

  /// * Safe Setters
  Future<bool> setString(String key, String value) async =>
      await _prefs?.setString(key, value) ?? false;

  Future<bool> setInt(String key, int value) async =>
      await _prefs?.setInt(key, value) ?? false;

  Future<bool> setDouble(String key, double value) async =>
      await _prefs?.setDouble(key, value) ?? false;

  Future<bool> setBool(String key, bool value) async =>
      await _prefs?.setBool(key, value) ?? false;

  Future<bool> setStringList(String key, List<String> value) async =>
      await _prefs?.setStringList(key, value) ?? false;

  /// * Other helpers
  bool contains(String key) => _prefs?.containsKey(key) ?? false;

  Future<bool> remove(String key) async => await _prefs?.remove(key) ?? false;

  Future<bool> clear() async => await _prefs?.clear() ?? false;
}
