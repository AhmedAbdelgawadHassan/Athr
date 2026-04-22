import 'package:athr/features/reminder/data/models/reminder_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> init() async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      return;
    }

    tz.initializeTimeZones();
    try {
      final timezoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezoneName));
    } catch (_) {}

    const androidInit = AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosInit = DarwinInitializationSettings();
    const initSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);

    try {
      await _plugin.initialize(initSettings);
      _isInitialized = true;
    } catch (e) {
      debugPrint('Notification initialize error: $e');
      _isInitialized = false;
    }

    if (!_isInitialized) return;

    try {
      if (Platform.isAndroid) {
        await _plugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
      } else if (Platform.isIOS) {
        await _plugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(alert: true, badge: true, sound: true);
      }
    } on MissingPluginException catch (e) {
      debugPrint('Notification permission plugin missing: $e');
    } catch (e) {
      debugPrint('Notification permission error: $e');
    }
  }

  Future<void> scheduleReminderNotification(ReminderModel reminder) async {
    if (!_isInitialized) return;
    final id = _notificationId(reminder.id);
    final title = reminder.title;
    final body = 'وقت التذكير: ${DateFormat('hh:mm a').format(reminder.time)}';

    const androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Reminder Notifications',
      channelDescription: 'Notifications for user reminders',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final scheduledDate = _nextValidDate(reminder.time, reminder.isDaily);
    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents:
            reminder.isDaily ? DateTimeComponents.time : null,
      );
    } on MissingPluginException catch (e) {
      debugPrint('Schedule plugin missing: $e');
      return;
    } catch (e) {
      // Some Android devices reject exact alarms without extra permission.
      try {
        await _plugin.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(scheduledDate, tz.local),
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents:
              reminder.isDaily ? DateTimeComponents.time : null,
        );
        debugPrint('Exact schedule fallback used: $e');
      } on MissingPluginException catch (fallbackError) {
        debugPrint('Schedule fallback plugin missing: $fallbackError');
      }
    }
  }

  Future<void> cancelReminderNotification(String reminderId) async {
    if (!_isInitialized) return;
    try {
      await _plugin.cancel(_notificationId(reminderId));
    } on MissingPluginException catch (e) {
      debugPrint('Cancel plugin missing: $e');
    }
  }

  int _notificationId(String reminderId) {
    return reminderId.hashCode.abs();
  }

  DateTime _nextValidDate(DateTime date, bool isDaily) {
    final now = DateTime.now();
    if (isDaily) {
      DateTime next = DateTime(
        now.year,
        now.month,
        now.day,
        date.hour,
        date.minute,
      );
      if (!next.isAfter(now)) {
        next = next.add(const Duration(days: 1));
      }
      return next;
    }
    if (!date.isAfter(now)) {
      return now.add(const Duration(seconds: 5));
    }
    return date;
  }
}
