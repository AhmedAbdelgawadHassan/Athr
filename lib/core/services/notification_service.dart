import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// ── top-level function مطلوبة للـ background callback ──
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  debugPrint('🔔 BG tap: actionId=${response.actionId}');
  if (response.actionId == NotificationService.stopAdhanActionId) {
    NotificationService.onStopAdhanFromNotification?.call();
  }
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  static const String stopAdhanActionId = 'STOP_ADHAN';

  static const Map<String, int> prayerIds = {
    'Fajr': 100,
    'Dhuhr': 101,
    'Asr': 102,
    'Maghrib': 103,
    'Isha': 104,
  };

  // يُسجَّل من AdhanCubit
  static void Function()? onStopAdhanFromNotification;

  Future<void> init() async {
    if (_isInitialized) return;
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;

    tz.initializeTimeZones();
    try {
      final timezoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezoneName));
      debugPrint('🌍 Timezone: $timezoneName');
    } catch (e) {
      tz.setLocalLocation(tz.getLocation('UTC'));
      debugPrint('⚠️ Timezone fallback UTC: $e');
    }

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );

    final result = await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onForegroundTap,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    debugPrint('🔔 NotificationService init: $result');
    _isInitialized = true;

    await _requestPermissions();
    await _createChannels();
  }

  void _onForegroundTap(NotificationResponse response) {
    debugPrint('🔔 FG tap: actionId=${response.actionId}');
    if (response.actionId == stopAdhanActionId) {
      onStopAdhanFromNotification?.call();
    }
  }

  Future<void> _requestPermissions() async {
    try {
      if (Platform.isAndroid) {
        final android = _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
        final granted = await android?.requestNotificationsPermission();
        debugPrint('📱 Notification permission granted: $granted');
        await android?.requestExactAlarmsPermission();
      } else if (Platform.isIOS) {
        final ios = _plugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
        await ios?.requestPermissions(alert: true, badge: true, sound: true);
      }
    } catch (e) {
      debugPrint('⚠️ Permission error: $e');
    }
  }

  Future<void> _createChannels() async {
    if (!Platform.isAndroid) return;
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return;

    // channel الأذان - بدون صوت لأن الصوت من audioplayers
    const adhanChannel = AndroidNotificationChannel(
      'adhan_channel',
      'Prayer Adhan',
      description: 'Adhan notifications for prayer times',
      importance: Importance.max,
      playSound: false,
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
    debugPrint('✅ Channels created');
  }

  // // ── جدولة إشعار الأذان مسبقاً ──
  // Future<void> scheduleAdhan({
  //   required String prayerName,
  //   required String prayerNameEn,
  //   required DateTime prayerTime,
  // }) async {
  //   if (!_isInitialized) {
  //     debugPrint('⚠️ NotificationService not initialized!');
  //     return;
  //   }

  //   if (!prayerTime.isAfter(DateTime.now())) {
  //     debugPrint('⏩ Skipping $prayerNameEn - passed');
  //     return;
  //   }

  //   final id =
  //       prayerIds[prayerNameEn] ?? prayerNameEn.hashCode.abs() % 900 + 100;

  //   final androidDetails = AndroidNotificationDetails(
  //     'adhan_channel',
  //     'Prayer Adhan',
  //     importance: Importance.max,
  //     priority: Priority.max,
  //     playSound: false,
  //     enableVibration: true,
  //     fullScreenIntent: true,
  //     ongoing: true,
  //     autoCancel: false,
  //     actions: const [
  //       AndroidNotificationAction(
  //         stopAdhanActionId,
  //         '🔇 إيقاف الأذان',
  //         cancelNotification: true,
  //         showsUserInterface: false,
  //       ),
  //     ],
  //   );

  //   final tzTime = tz.TZDateTime.from(prayerTime, tz.local);

  //   await _plugin.zonedSchedule(
  //     id,
  //     '🕌 حان وقت $prayerName',
  //     'قوم صلي يبرنس يلا ',
  //     tzTime,
  //     NotificationDetails(
  //       android: androidDetails,
  //       iOS: const DarwinNotificationDetails(
  //         interruptionLevel: InterruptionLevel.timeSensitive,
  //         presentSound: false,
  //       ),
  //     ),
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //   );

  //   debugPrint('✅ Scheduled: $prayerNameEn at $tzTime');
  // }

  // ── إشعار فوري لما الأذان يبدأ فعلاً ──
  Future<void> showActiveAdhanNotification({
    required String prayerName,
    required String prayerNameEn,
  }) async {
    if (!_isInitialized) return;

    final id =
        prayerIds[prayerNameEn] ?? prayerNameEn.hashCode.abs() % 900 + 100;

    final androidDetails = AndroidNotificationDetails(
      'adhan_channel',
      'Prayer Adhan',
      importance: Importance.max,
      priority: Priority.max,
      playSound: false,
      enableVibration: true,
      fullScreenIntent: true,
      ongoing: true,
      autoCancel: false,
      actions: const [
        AndroidNotificationAction(
          stopAdhanActionId,
          '🔇 إيقاف الأذان',
          cancelNotification: true,
          showsUserInterface: false,
        ),
      ],
    );

    await _plugin.show(
      id,
      '🕌 حان وقت $prayerName',
      'اضغط لإيقاف الأذان',
      NotificationDetails(
        android: androidDetails,
        iOS: const DarwinNotificationDetails(
          interruptionLevel: InterruptionLevel.timeSensitive,
          presentSound: false,
        ),
      ),
    );

    debugPrint('🔔 Active adhan shown: $prayerNameEn');
  }

  Future<void> cancelAdhan(String prayerNameEn) async {
    final id =
        prayerIds[prayerNameEn] ?? prayerNameEn.hashCode.abs() % 900 + 100;
    await _plugin.cancel(id);
    debugPrint('🗑️ Cancelled: $prayerNameEn');
  }

  Future<void> cancelAllAdhan() async {
    for (final id in prayerIds.values) {
      await _plugin.cancel(id);
    }
    debugPrint('🗑️ Cancelled all adhan');
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
      DateTime next =
          DateTime(now.year, now.month, now.day, date.hour, date.minute);
      if (!next.isAfter(now)) next = next.add(const Duration(days: 1));
      return next;
    }
    return date.isAfter(now) ? date : now.add(const Duration(seconds: 5));
  }
}
