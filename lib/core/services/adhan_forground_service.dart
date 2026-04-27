// lib/core/services/adhan_foreground_service.dart
import 'package:athr/core/services/adhan_audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
class AdhanTaskHandler extends TaskHandler {
  final Set<String> _firedToday = {};

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    debugPrint('🟢 FG Service started');
    // ✅ نهيئ الصوت بس - مش الإشعارات لأنها محتاجة Context
    await AdhanAudioService().init();
  }

  @override
  void onRepeatEvent(DateTime timestamp) async {
    final now = DateTime.now();
    final todayKey = '${now.year}-${now.month}-${now.day}';

    if (!_firedToday.contains('__$todayKey')) {
      _firedToday.clear();
      _firedToday.add('__$todayKey');
      debugPrint('🔄 FG: Daily reset');
    }

    final prayers = await _loadPrayerTimes();
    if (prayers.isEmpty) {
      debugPrint('⚠️ FG: No prayer times in prefs');
      return;
    }

    for (final entry in prayers.entries) {
      final nameEn = entry.key;
      if (_firedToday.contains(nameEn)) continue;
      if (entry.value['enabled'] != 'true') continue;

      final parts = entry.value['time']!.split(':');
      if (parts.length < 2) continue;

      final prayerTime = DateTime(
        now.year, now.month, now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );

      final diffSeconds = now.difference(prayerTime).inSeconds;
      if (diffSeconds >= 0 && diffSeconds < 90) {
        debugPrint('🕌 FG firing: $nameEn diff=${diffSeconds}s');
        _firedToday.add(nameEn);

        final arabicName = entry.value['name'] ?? nameEn;

        // ✅ شغّل الصوت
        await AdhanAudioService().playAdhan();

        // ✅ حدّث نص الـ FG notification نفسه بدل flutter_local_notifications
        await FlutterForegroundTask.updateService(
          notificationTitle: '🕌 حان وقت صلاة $arabicName',
          notificationText: 'يلا علي الصلاة يبرنس 🫵👊',
        );

        // ✅ أبلّغ الـ main isolate
        FlutterForegroundTask.sendDataToMain('ADHAN_STARTED:$arabicName');
        break;
      }
    }
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    debugPrint('🔴 FG Service destroyed');
    await AdhanAudioService().stopAdhan();
  }

  @override
  void onReceiveData(Object data) async {
    debugPrint('📨 FG received: $data');
    if (data == 'STOP_ADHAN') {
      await AdhanAudioService().stopAdhan();
      // رجّع الـ notification لحالته الأصلية
      await FlutterForegroundTask.updateService(
        notificationTitle: 'أثر - مواقيت الصلاة',
        notificationText: 'التطبيق يعمل في الخلفية لتنبيهك بمواقيت الصلاة',
      );
      FlutterForegroundTask.sendDataToMain('ADHAN_STOPPED');
      debugPrint('⏹️ FG: Adhan stopped');
    }
  }

  Future<Map<String, Map<String, String>>> _loadPrayerTimes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final result = <String, Map<String, String>>{};
      for (final nameEn in ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha']) {
        final time = prefs.getString('prayer_time_$nameEn');
        if (time == null) continue;
        result[nameEn] = {
          'time': time,
          'name': prefs.getString('prayer_name_$nameEn') ?? nameEn,
          'enabled': (prefs.getBool('adhan_$nameEn') ?? true).toString(),
        };
      }
      debugPrint('📖 FG loaded prayers: ${result.keys.join(", ")}');
      return result;
    } catch (e) {
      debugPrint('❌ FG loadPrayerTimes: $e');
      return {};
    }
  }
}

class AdhanForegroundService {
  static Future<void> init() async {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'adhan_foreground',
        channelName: 'Adhan Service',
        channelDescription: 'يعمل في الخلفية لتنبيهك بمواقيت الصلاة',
        channelImportance: NotificationChannelImportance.HIGH,
        priority: NotificationPriority.HIGH,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(30000),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  static Future<void> start() async {
    if (await FlutterForegroundTask.isRunningService) {
      debugPrint('ℹ️ FG Service already running');
      return;
    }
    await FlutterForegroundTask.startService(
      serviceId: 300,
      notificationTitle: 'أثر - مواقيت الصلاة',
      notificationText: 'التطبيق يعمل في الخلفية لتنبيهك بمواقيت الصلاة',
      notificationIcon: null,
      callback: startCallback,
    );
    debugPrint('✅ FG Service started');
  }

  static Future<void> stop() async {
    await FlutterForegroundTask.stopService();
  }

  static void sendStopAdhan() {
    debugPrint('📤 Sending STOP_ADHAN to FG');
    FlutterForegroundTask.sendDataToTask('STOP_ADHAN');
  }
}

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(AdhanTaskHandler());
}