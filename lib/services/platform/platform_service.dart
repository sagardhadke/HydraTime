import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PlatformService {
  static final PlatformService _instance = PlatformService._internal();
  factory PlatformService() => _instance;
  PlatformService._internal();

  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  PackageInfo? _packageInfo;

  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isWeb => kIsWeb;

  /// Get app version
  Future<String> getAppVersion() async {
    if (_packageInfo == null) {
      _packageInfo = await PackageInfo.fromPlatform();
    }
    return _packageInfo?.version ?? '1.0.0';
  }

  /// Get build number
  Future<String> getBuildNumber() async {
    if (_packageInfo == null) {
      _packageInfo = await PackageInfo.fromPlatform();
    }
    return _packageInfo?.buildNumber ?? '1';
  }

  /// Get device info
  Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      if (isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return {
          'platform': 'Android',
          'model': androidInfo.model,
          'manufacturer': androidInfo.manufacturer,
          'version': androidInfo.version.release,
          'sdkInt': androidInfo.version.sdkInt,
          'deviceId': androidInfo.id,
        };
      } else if (isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return {
          'platform': 'iOS',
          'model': iosInfo.model,
          'systemName': iosInfo.systemName,
          'systemVersion': iosInfo.systemVersion,
          'identifierForVendor': iosInfo.identifierForVendor,
        };
      }
      return {'platform': 'Unknown'};
    } catch (e) {
      debugPrint('❌ Failed to get device info:  $e');
      return {};
    }
  }

  /// Check if device has battery optimization enabled
  Future<bool> isBatteryOptimizationEnabled() async {
    try {
      if (isAndroid) {
        // On Android, check if app is in restricted battery mode
        // This requires platform channel implementation
        return false; // Default:  assume not optimized
      }
      return false; // iOS doesn't have aggressive battery optimization like Android
    } catch (e) {
      debugPrint('❌ Failed to check battery optimization:  $e');
      return false;
    }
  }

  /// Check if app is in low power mode (iOS)
  Future<bool> isLowPowerModeEnabled() async {
    try {
      if (isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        // In iOS 9+, check if device is in low power mode
        // This requires platform channel for actual implementation
        return false; // Default: assume not in low power
      }
      return false;
    } catch (e) {
      debugPrint('❌ Failed to check low power mode:  $e');
      return false;
    }
  }

  /// Get optimal notification interval based on device
  Duration getOptimalNotificationInterval() {
    if (isAndroid) {
      return const Duration(minutes: 15); // More frequent on Android
    } else if (isIOS) {
      return const Duration(minutes: 30); // Less frequent on iOS (battery)
    }
    return const Duration(minutes: 15);
  }

  /// Log device and app info
  Future<void> logSystemInfo() async {
    try {
      final version = await getAppVersion();
      final buildNumber = await getBuildNumber();
      final deviceInfo = await getDeviceInfo();

      debugPrint('📱 System Info:');
      debugPrint('  App Version: $version');
      debugPrint('  Build Number: $buildNumber');
      debugPrint('  Device:  ${deviceInfo['model']}');
      debugPrint('  Platform: ${deviceInfo['platform']}');
    } catch (e) {
      debugPrint('❌ Failed to log system info: $e');
    }
  }
}
