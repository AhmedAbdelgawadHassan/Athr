import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// ── top-level function مطلوبة للـ background callback ──
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) async {
  debugPrint('🔔 BG tap: actionId=${response.actionId}');
  if (response.actionId == NotificationService.stopAdhanActionId) {
    // ✅ الحل: نكتب الـ flag في SharedPreferences عشان الـ FG Service يشوفه
    // (الـ static variables مش بتتشاركش بين الـ isolates)
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('stop_adhan_request', true);
    debugPrint('✅ stop_adhan_request saved to SharedPrefs');
  }
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  static const String stopAdhanActionId = 'STOP_ADHAN';
  static const int adhanNotificationId = 999;

  static const Map<String, int> prayerIds = {
    'Fajr': 100,
    'Dhuhr': 101,
    'Asr': 102,
    'Maghrib': 103,
    'Isha': 104,
  };

  // يُسجَّل من AdhanCubit (للـ foreground فقط)
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

    // ✅ channel الأذان - بصوت الأذان الـ custom
    // الملف لازم يكون في: android/app/src/main/res/raw/adhan.mp3
    const adhanChannel = AndroidNotificationChannel(
      'adhan_sound_channel',
      'Prayer Adhan Sound',
      description: 'Adhan notifications with adhan sound',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      sound: RawResourceAndroidNotificationSound('adhan'),
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

  // ── إشعار الأذان الفعلي مع صوت وزرار إيقاف ──
  Future<void> showAdhanNotification({
    required String prayerName,
    required String prayerNameEn,
  }) async {
    if (!_isInitialized) {
      await init();
    }

    // إلغاء أي إشعار أذان قديم أولاً
    await _plugin.cancel(adhanNotificationId);

    final androidDetails = AndroidNotificationDetails(
      'adhan_sound_channel',
      'Prayer Adhan Sound',
      importance: Importance.max,
      priority: Priority.max,
      sound: const RawResourceAndroidNotificationSound('adhan'),
      playSound: true,
      enableVibration: true,
      ongoing: true,
      autoCancel: false,
      fullScreenIntent: true,
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      styleInformation: BigTextStyleInformation(
        'يلا علي الصلاة يبرنس 🫵👊',
        summaryText: prayerName,
      ),
      actions: const [
        AndroidNotificationAction(
          stopAdhanActionId,
          '🔇 إيقاف الأذان',
          cancelNotification: true,
          showsUserInterface: false,
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'adhan.mp3',
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    await _plugin.show(
      adhanNotificationId,
      '🕌 حان وقت صلاة $prayerName',
      'يلا علي الصلاة يبرنس 🫵👊',
      NotificationDetails(android: androidDetails, iOS: iosDetails),
    );

    debugPrint('🔔 Adhan notification shown for: $prayerNameEn');
  }

  // ── إلغاء إشعار الأذان ──
  Future<void> cancelAdhanNotification() async {
    await _plugin.cancel(adhanNotificationId);
    debugPrint('🗑️ Adhan notification cancelled');
  }

  Future<void> cancelAdhan(String prayerNameEn) async {
    final id =
        prayerIds[prayerNameEn] ?? prayerNameEn.hashCode.abs() % 900 + 100;
    await _plugin.cancel(id);
    await _plugin.cancel(adhanNotificationId);
    debugPrint('🗑️ Cancelled: $prayerNameEn');
  }

  Future<void> cancelAllAdhan() async {
    for (final id in prayerIds.values) {
      await _plugin.cancel(id);
    }
    await _plugin.cancel(adhanNotificationId);
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