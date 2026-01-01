import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  /// Request notification permission
  Future<bool> requestNotificationPermission() async {
    try {
      final status = await Permission.notification.request();

      if (status.isDenied) {
        debugPrint('⚠️  Notification permission denied');
        return false;
      } else if (status.isPermanentlyDenied) {
        debugPrint('⛔ Notification permission permanently denied');
        openAppSettings();
        return false;
      }

      debugPrint('✅ Notification permission granted');
      return true;
    } catch (e) {
      debugPrint('❌ Failed to request notification permission: $e');
      return false;
    }
  }

  /// Check notification permission
  Future<bool> hasNotificationPermission() async {
    try {
      final status = await Permission.notification.status;
      return status.isGranted;
    } catch (e) {
      debugPrint('❌ Failed to check notification permission: $e');
      return false;
    }
  }

  /// Request multiple permissions
  Future<Map<Permission, PermissionStatus>> requestPermissions(
    List<Permission> permissions,
  ) async {
    try {
      final statuses = await permissions.request();

      for (final permission in statuses.entries) {
        if (permission.value.isDenied) {
          debugPrint('⚠️  ${permission.key} permission denied');
        } else if (permission.value.isPermanentlyDenied) {
          debugPrint('⛔ ${permission.key} permission permanently denied');
        } else if (permission.value.isGranted) {
          debugPrint('✅ ${permission.key} permission granted');
        }
      }

      return statuses;
    } catch (e) {
      debugPrint('❌ Failed to request permissions: $e');
      return {};
    }
  }

  /// Open app settings
  Future<void> openAppSettings() async {
    try {
      await openAppSettings();
      debugPrint('📲 Opening app settings');
    } catch (e) {
      debugPrint('❌ Failed to open app settings: $e');
    }
  }
}
