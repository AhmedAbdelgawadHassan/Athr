// ignore_for_file: unintended_html_in_doc_comment

import 'package:athr/core/utils/app_assets.dart';
import 'package:flutter/material.dart';

class PrayerTimeItemModel {
  final String name;
  final String time;
  final String icon;
  final Color color;

  PrayerTimeItemModel({
    required this.name,
    required this.time,
    required this.icon,
    required this.color,
  });

  /// 🔹 تحويل من API → List<PrayerTimeItemModel>
  static List<PrayerTimeItemModel> fromApi(Map<String, dynamic> json) {   // this function is used to convert the API response to a list of PrayerTimeItemModel
    final timings = json['data']['timings'];

    return [
      PrayerTimeItemModel(
        name: "الفجر",
        time: _formatTime(timings['Fajr'], isFajr: true),
        icon: AppAssets.fagr,
        color: const Color(0xFFE6E9F5),
      ),
      PrayerTimeItemModel(
        name: "الظهر",
        time: _formatTime(timings['Dhuhr']),
        icon: AppAssets.dohr,
        color: const Color(0xFFD3E3F7),
      ),
      PrayerTimeItemModel(
        name: "العصر",
        time: _formatTime(timings['Asr']),
        icon: AppAssets.asr,
        color: const Color(0xFFE6D3A3),
      ),
      PrayerTimeItemModel(
        name: "المغرب",
        time: _formatTime(timings['Maghrib']),
        icon: AppAssets.magreb,
        color: const Color(0xFFF3D6D6),
      ),
      PrayerTimeItemModel(
        name: "العشاء",
        time: _formatTime(timings['Isha']),
        icon: AppAssets.eshaa,
        color: const Color(0xFFE3E5EA),
      ),
    ];
  }

  /// 🔹 تنظيف + تعديل + تحويل 12 ساعة
  static String _formatTime(String time, {bool isFajr = false}) {
    try {
     // clean the time from any additional text like EET or any other text 
     // اي مسافه فاضيه " " تيجي بعد التايم شيلتها
      String cleanTime = time.split(' ')[0];



      // convert the time to a DateTime object with a fake date
      DateTime parsedTime = DateTime.parse("2026-01-01 $cleanTime");

       // subtract 8 minutes from the fajr time because the api increase the time by 8 minutes
      if (isFajr) {
        parsedTime = parsedTime.subtract(const Duration(minutes: 8));
      }


    // convert the time to 12 hour format Not 24 hour format
    
      int hour = parsedTime.hour;
      int minute = parsedTime.minute;

      int displayHour = hour % 12;  // convert the time to 12 hour format Not 24 hour format
      if (displayHour == 0) displayHour = 12;  

      String minuteStr = minute.toString().padLeft(2, '0');  // add a zero to the minute if it is less than 10
 
      return "$displayHour:$minuteStr";
    } catch (e) {
      return time.split(' ')[0];
    }
  }
}