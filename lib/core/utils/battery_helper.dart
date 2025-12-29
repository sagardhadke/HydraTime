import 'package:flutter/foundation.dart';
import 'package:hydra_time/services/platform/platform_service.dart';

class BatteryHelper {
  static final BatteryHelper _instance = BatteryHelper._internal();
  factory BatteryHelper() => _instance;
  BatteryHelper._internal();

  final PlatformService _platformService = PlatformService();

  /// Get battery-optimized notification schedule
  Future<NotificationScheduleConfig> getBatteryOptimizedSchedule({
    required Duration preferredInterval,
    required bool isBackgroundTask,
  }) async {
    try {
      final isOptimized = await _platformService.isBatteryOptimizationEnabled();
      final isLowPowerMode = await _platformService.isLowPowerModeEnabled();

      if (isOptimized || isLowPowerMode) {
        // Reduce frequency in low-power mode
        return NotificationScheduleConfig(
          interval: preferredInterval * 1.5,
          allowWhileIdle: true,
          requiresCharging: false,
          requiresBatteryNotLow: true,
        );
      }

      return NotificationScheduleConfig(
        interval: preferredInterval,
        allowWhileIdle: true,
        requiresCharging: false,
        requiresBatteryNotLow: false,
      );
    } catch (e) {
      debugPrint('❌ Failed to get battery optimized schedule: $e');
      return NotificationScheduleConfig(
        interval: preferredInterval,
        allowWhileIdle: true,
        requiresCharging: false,
        requiresBatteryNotLow: false,
      );
    }
  }

  /// Smart notification batching
  List<T> batchNotifications<T>(
    List<T> notifications, {
    required int batchSize,
  }) {
    if (notifications.length <= batchSize) {
      return notifications;
    }

    // Return only the most important notifications
    return notifications.sublist(0, batchSize);
  }

  /// Should schedule notification now
  Future<bool> shouldScheduleNotification({
    required bool isBackgroundTask,
  }) async {
    try {
      final isLowPowerMode = await _platformService.isLowPowerModeEnabled();

      if (isLowPowerMode && isBackgroundTask) {
        debugPrint('⚡ Skipping background task due to low power mode');
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('❌ Failed to check if should schedule:  $e');
      return true; // Default:  schedule the notification
    }
  }
}

class NotificationScheduleConfig {
  final Duration interval;
  final bool allowWhileIdle;
  final bool requiresCharging;
  final bool requiresBatteryNotLow;

  NotificationScheduleConfig({
    required this.interval,
    required this.allowWhileIdle,
    required this.requiresCharging,
    required this.requiresBatteryNotLow,
  });
}
