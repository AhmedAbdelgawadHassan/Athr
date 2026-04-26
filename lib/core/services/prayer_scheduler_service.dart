// lib/core/services/prayer_scheduler_service.dart
import 'package:athr/core/services/notification_service.dart';
import 'package:athr/features/azan/data/models/prayer_model.dart';
import 'package:flutter/foundation.dart';

class PrayerSchedulerService {
  PrayerSchedulerService._();
  static final PrayerSchedulerService instance = PrayerSchedulerService._();

  // بنلغي أي إشعارات قديمة بس مش بنجدول جديدة
  // الـ timer في AdhanCubit هو المسؤول عن تشغيل الأذان
  Future<void> scheduleTodayPrayers(List<PrayerModel> prayers) async {
    await NotificationService.instance.cancelAllAdhan();
    debugPrint('📅 Old adhan notifications cleared');
  }

  Future<void> cancelPrayer(String prayerNameEn) async {
    await NotificationService.instance.cancelAdhan(prayerNameEn);
  }

  Future<void> reschedulePrayer(PrayerModel prayer) async {
    if (!prayer.isEnabled) {
      await cancelPrayer(prayer.nameEn);
    }
    // مفيش جدولة - الـ timer هيتعامل معاها
  }
}