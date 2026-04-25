import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  static const Map<String, int> prayerIds = {
    'Fajr':    100,
    'Dhuhr':   101,
    'Asr':     102,
    'Maghrib': 103,
    'Isha':    104,
  };

  Future<void> init() async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;

    tz.initializeTimeZones();
    try {
      final timezoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezoneName));
    } catch (e) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );

    await _plugin.initialize(settings);
    _isInitialized = true;
    await _requestPermissions();
    await _createChannels();
  }

  Future<void> _requestPermissions() async {
    try {
      if (Platform.isAndroid) {
        final android = _plugin.resolvePlatformSpecificImplementation
            <AndroidFlutterLocalNotificationsPlugin>();
        await android?.requestNotificationsPermission();
        await android?.requestExactAlarmsPermission();
      } else if (Platform.isIOS) {
        final ios = _plugin.resolvePlatformSpecificImplementation
            <IOSFlutterLocalNotificationsPlugin>();
        await ios?.requestPermissions(alert: true, badge: true, sound: true);
      }
    } catch (e) {
      debugPrint('Permission error: $e');
    }
  }

  Future<void> _createChannels() async {
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _plugin.resolvePlatformSpecificImplementation
          <  AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return;

    const adhanChannel = AndroidNotificationChannel(
      'adhan_channel',
      'Prayer Adhan',
      description: 'Adhan notifications for prayer times',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    const reminderChannel = AndroidNotificationChannel(
      'reminder_channel',
      'Reminder Notifications',
      description: 'User reminders',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    await androidPlugin.createNotificationChannel(adhanChannel);
    await androidPlugin.createNotificationChannel(reminderChannel);
  }

  // ───── الأذان ─────
  Future<void> scheduleAdhan({
    required String prayerName,
    required String prayerNameEn,
    required DateTime prayerTime,
  }) async {
    if (!_isInitialized) return;

    if (!prayerTime.isAfter(DateTime.now())) {
      debugPrint('⏩ Skipping $prayerNameEn - time already passed');
      return;
    }

    final id = prayerIds[prayerNameEn] ??
        prayerNameEn.hashCode.abs() % 900 + 100;

    const androidDetails = AndroidNotificationDetails(
      'adhan_channel',
      'Prayer Adhan',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      fullScreenIntent: true,
    );

    await _plugin.zonedSchedule(
      id,
      '🕌 حان وقت $prayerName',
      'الله أكبر الله أكبر',
      tz.TZDateTime.from(prayerTime, tz.local),
      const NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(
          interruptionLevel: InterruptionLevel.timeSensitive,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    debugPrint('✅ Scheduled adhan: $prayerNameEn at $prayerTime');
  }

  Future<void> cancelAdhan(String prayerNameEn) async {
    final id = prayerIds[prayerNameEn] ??
        prayerNameEn.hashCode.abs() % 900 + 100;
    await _plugin.cancel(id);
    debugPrint('🗑️ Cancelled adhan: $prayerNameEn');
  }

  Future<void> cancelAllAdhan() async {
    for (final id in prayerIds.values) {
      await _plugin.cancel(id);
    }
    debugPrint('🗑️ Cancelled all adhan notifications');
  }

  // ───── Reminder ─────
  Future<void> scheduleReminder({
    required String id,
    required String title,
    required DateTime time,
    required bool isDaily,
  }) async {
    if (!_isInitialized) return;

    final notifId = id.hashCode.abs();

    const androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      importance: Importance.max,
      priority: Priority.max,
    );

    final nextTime = _nextValidDate(time, isDaily);

    await _plugin.zonedSchedule(
      notifId,
      title,
      'تذكير',
      tz.TZDateTime.from(nextTime, tz.local),
      const NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: isDaily ? DateTimeComponents.time : null,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelReminder(String id) async {
    await _plugin.cancel(id.hashCode.abs());
  }

  DateTime _nextValidDate(DateTime date, bool isDaily) {
    final now = DateTime.now();
    if (isDaily) {
      DateTime next = DateTime(
          now.year, now.month, now.day, date.hour, date.minute);
      if (!next.isAfter(now)) next = next.add(const Duration(days: 1));
      return next;
    }
    return date.isAfter(now) ? date : now.add(const Duration(seconds: 5));
  }
}