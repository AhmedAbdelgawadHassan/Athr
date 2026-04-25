import 'package:athr/core/services/notification_service.dart';
import 'package:athr/features/azan/data/models/prayer_model.dart';
import 'package:flutter/foundation.dart';

class PrayerSchedulerService {
  PrayerSchedulerService._();
  static final PrayerSchedulerService instance = PrayerSchedulerService._();

  static const Map<String, int> _prayerIds = {
    'Fajr':    100,
    'Dhuhr':   101,
    'Asr':     102,
    'Maghrib': 103,
    'Isha':    104,
  };

  Future<void> scheduleTodayPrayers(List<PrayerModel> prayers) async {
    await NotificationService.instance.cancelAllAdhan();

    int scheduled = 0;
    for (final prayer in prayers) {
      if (!prayer.isEnabled) {
        debugPrint('⏭️ Skipping ${prayer.nameEn} - disabled');
        continue;
      }
      await NotificationService.instance.scheduleAdhan(
        prayerName: prayer.name,
        prayerNameEn: prayer.nameEn,
        prayerTime: prayer.timeAsDateTime,
      );
      scheduled++;
    }
    debugPrint('📅 Scheduled $scheduled prayers for today');
  }

  Future<void> cancelPrayer(String prayerNameEn) async {
    await NotificationService.instance.cancelAdhan(prayerNameEn);
    debugPrint('🗑️ Cancelled adhan for $prayerNameEn');
  }

  Future<void> reschedulePrayer(PrayerModel prayer) async {
    if (!prayer.isEnabled) {
      await cancelPrayer(prayer.nameEn);
      return;
    }
    await NotificationService.instance.scheduleAdhan(
      prayerName: prayer.name,
      prayerNameEn: prayer.nameEn,
      prayerTime: prayer.timeAsDateTime,
    );
    debugPrint('🔄 Rescheduled adhan for ${prayer.nameEn}');
  }
}