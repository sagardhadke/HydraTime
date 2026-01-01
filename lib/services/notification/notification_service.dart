import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hydra_time/services/notification/notification_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final NotificationHandler _handler = NotificationHandler();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  /// Initialize notifications
  Future<void> initNotification() async {
    if (_isInitialized) return;

    try {
      tz.initializeTimeZones();

      // Android settings
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS settings
      final DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            notificationCategories: [
              DarwinNotificationCategory(
                'waterReminder',
                actions: [
                  DarwinNotificationAction.plain(
                    'id_1',
                    'Mark as Done',
                    options: <DarwinNotificationActionOption>{
                      DarwinNotificationActionOption.foreground,
                    },
                  ),
                ],
              ),
            ],
          );

      final InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // Initialize plugin
      final bool? result = await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
              await _handler.handleNotificationTap(
                notificationResponse.payload,
              );
            },
        onDidReceiveBackgroundNotificationResponse: _notificationTapBackground,
      );

      if (result != null && result) {
        // Create notification channels
        await _handler.createNotificationChannels();

        // Request permissions
        await _handler.requestNotificationPermission();

        _isInitialized = true;
        debugPrint('✅ Notification service initialized');
      }
    } catch (e) {
      debugPrint('❌ Failed to initialize notifications: $e');
    }
  }

  /// Show instant notification
  Future<void> instantNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? channelId,
  }) async {
    try {
      await _notificationsPlugin.show(
        id,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelId ?? 'reminders',
            'Notifications',
            channelDescription: 'Notification channel for water reminders',
            importance: Importance.high,
            priority: Priority.high,
            enableVibration: true,
            showWhen: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: payload,
      );

      debugPrint('📳 Instant notification shown: $title');
    } catch (e) {
      debugPrint('❌ Failed to show instant notification: $e');
    }
  }

  /// Schedule reminder notification
  Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    String? payload,
    String? channelId,
    bool androidAllowWhileIdle = true,
  }) async {
    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelId ?? 'reminders',
            'Reminders',
            channelDescription: 'Notification channel for water reminders',
            importance: Importance.high,
            priority: Priority.high,
            enableVibration: true,
            showWhen: true,
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

      debugPrint('📅 Reminder scheduled: $title at $scheduledDate');
    } catch (e) {
      debugPrint('❌ Failed to schedule reminder: $e');
    }
  }

  /// Schedule repeating notification
  Future<void> scheduleRepeatingNotification({
    required int id,
    required String title,
    required String body,
    required RepeatInterval interval,
    String? payload,
    String? channelId,
  }) async {
    try {
      await _notificationsPlugin.periodicallyShow(
        id,
        title,
        body,
        interval,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelId ?? 'reminders',
            'Reminders',
            channelDescription: 'Notification channel for water reminders',
            importance: Importance.high,
            priority: Priority.high,
            enableVibration: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );

      debugPrint('🔄 Repeating notification scheduled: $title');
    } catch (e) {
      debugPrint('❌ Failed to schedule repeating notification: $e');
    }
  }

  /// Cancel notification
  Future<void> cancelNotification(int id) async {
    try {
      await _notificationsPlugin.cancel(id);
      debugPrint('✅ Notification $id cancelled');
    } catch (e) {
      debugPrint('❌ Failed to cancel notification: $e');
    }
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    try {
      await _notificationsPlugin.cancelAll();
      debugPrint('✅ All notifications cancelled');
    } catch (e) {
      debugPrint('❌ Failed to cancel all notifications: $e');
    }
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      final pending = await _notificationsPlugin.pendingNotificationRequests();
      debugPrint('📊 Pending notifications:  ${pending.length}');
      return pending;
    } catch (e) {
      debugPrint('❌ Failed to get pending notifications: $e');
      return [];
    }
  }

  /// Batch schedule notifications
  Future<bool> batchScheduleReminders(
    List<Map<String, dynamic>> reminders,
  ) async {
    return await _handler.batchScheduleNotifications(reminders);
  }

  /// Set notification tap callback
  void setNotificationTapCallback(
    Future<void> Function(String? payload) callback,
  ) {
    _handler.setNotificationTapCallback(callback);
  }

  /// Request notification permission
  Future<bool> requestNotificationPermission() async {
    return await _handler.requestNotificationPermission();
  }

  /// Check notification permission
  Future<bool> hasNotificationPermission() async {
    return await _handler.hasNotificationPermission();
  }
}

@pragma('vm:entry-point')
void _notificationTapBackground(NotificationResponse notificationResponse) {
  debugPrint(
    'notification-background-tap received:  '
    '${notificationResponse.payload}',
  );
}
