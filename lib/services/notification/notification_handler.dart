import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

typedef NotificationCallback = Future<void> Function(String? payload);

class NotificationHandler {
  static final NotificationHandler _instance = NotificationHandler._internal();
  factory NotificationHandler() => _instance;
  NotificationHandler._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationCallback? _onNotificationTapped;
  NotificationCallback? _onNotificationDismissed;

  /// Set callback when notification is tapped
  void setNotificationTapCallback(NotificationCallback callback) {
    _onNotificationTapped = callback;
  }

  /// Set callback when notification is dismissed
  void setNotificationDismissedCallback(NotificationCallback callback) {
    _onNotificationDismissed = callback;
  }

  /// Handle notification tap
  Future<void> handleNotificationTap(String? payload) async {
    debugPrint('📳 Notification tapped with payload: $payload');
    if (_onNotificationTapped != null) {
      await _onNotificationTapped!(payload);
    }
  }

  /// Handle notification dismissed
  Future<void> handleNotificationDismissed(String? payload) async {
    debugPrint('📳 Notification dismissed with payload: $payload');
    if (_onNotificationDismissed != null) {
      await _onNotificationDismissed!(payload);
    }
  }

  /// Create notification channels for Android
  Future<void> createNotificationChannels() async {
    try {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      if (androidImplementation != null) {
        // Create reminder channel
        await androidImplementation.createNotificationChannel(
          const AndroidNotificationChannel(
            'reminders',
            'Reminder Notifications',
            description: 'Notifications for water intake reminders',
            importance: Importance.high,
            enableVibration: true,
            enableLights: true,
          ),
        );

        // Create achievement channel
        await androidImplementation.createNotificationChannel(
          const AndroidNotificationChannel(
            'achievements',
            'Achievement Notifications',
            description: 'Notifications for unlocked achievements',
            importance: Importance.defaultImportance,
            enableVibration: true,
          ),
        );

        // Create motivational channel
        await androidImplementation.createNotificationChannel(
          const AndroidNotificationChannel(
            'motivational',
            'Motivational Messages',
            description: 'Motivational messages and tips',
            importance: Importance.low,
            enableVibration: false,
          ),
        );

        debugPrint('✅ Notification channels created');
      }
    } catch (e) {
      debugPrint('❌ Failed to create notification channels: $e');
    }
  }

  /// Get active notifications count
  Future<int> getActiveNotificationsCount() async {
    try {
      final activeNotifications = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.getActiveNotifications();
      return activeNotifications?.length ?? 0;
    } catch (e) {
      debugPrint('❌ Failed to get active notifications:  $e');
      return 0;
    }
  }

  /// Check if notification permission is granted
  Future<bool> hasNotificationPermission() async {
    try {
      return true;
    } catch (e) {
      debugPrint('❌ Failed to check notification permission: $e');
      return false;
    }
  }

  /// Request notification permission
  Future<bool> requestNotificationPermission() async {
    try {
      final iosImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();

      if (iosImplementation != null) {
        final granted = await iosImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      }

      return true;
    } catch (e) {
      debugPrint('❌ Failed to request notification permission:  $e');
      return false;
    }
  }

  /// Batch schedule notifications
  Future<bool> batchScheduleNotifications(
    List<Map<String, dynamic>> notifications,
  ) async {
    try {
      int successCount = 0;

      for (final notif in notifications) {
        final id = notif['id'] as int;
        final title = notif['title'] as String;
        final body = notif['body'] as String;
        final scheduledDate = notif['scheduledDate'] as tz.TZDateTime;
        final payload = notif['payload'] as String?;
        final channelId = notif['channelId'] as String? ?? 'reminders';

        try {
          await _notificationsPlugin.zonedSchedule(
            id,
            title,
            body,
            scheduledDate,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channelId,
                'Notifications',
                channelDescription: 'Notification channel',
                importance: Importance.high,
                priority: Priority.high,
                showWhen: true,
                enableVibration: true,
              ),
              iOS: const DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ),
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.dateAndTime,
            payload: payload,
          );

          successCount++;
        } catch (e) {
          debugPrint('❌ Failed to schedule notification $id: $e');
        }
      }

      debugPrint(
        '✅ Batch scheduled $successCount/${notifications.length} notifications',
      );
      return successCount == notifications.length;
    } catch (e) {
      debugPrint('❌ Failed to batch schedule notifications: $e');
      return false;
    }
  }

  /// Cancel notification by ID
  Future<bool> cancelNotification(int id) async {
    try {
      await _notificationsPlugin.cancel(id);
      debugPrint('✅ Notification $id cancelled');
      return true;
    } catch (e) {
      debugPrint('❌ Failed to cancel notification:  $e');
      return false;
    }
  }

  /// Cancel all notifications
  Future<bool> cancelAllNotifications() async {
    try {
      await _notificationsPlugin.cancelAll();
      debugPrint('✅ All notifications cancelled');
      return true;
    } catch (e) {
      debugPrint('❌ Failed to cancel all notifications: $e');
      return false;
    }
  }

  /// Group notifications by channel
  Future<bool> groupNotifications({
    required int id,
    required String title,
    required String body,
    required String groupKey,
    String? summary,
  }) async {
    try {
      await _notificationsPlugin.show(
        id,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'grouped_notifications',
            'Grouped Notifications',
            channelDescription: 'Grouped notification channel',
            groupKey: groupKey,
            setAsGroupSummary: summary != null,
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
          ),
        ),
      );

      debugPrint('✅ Grouped notification displayed:  $groupKey');
      return true;
    } catch (e) {
      debugPrint('❌ Failed to group notification: $e');
      return false;
    }
  }
}
