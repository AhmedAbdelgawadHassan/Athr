class PrayerHelper {
  static String getNextPrayerName(List prayers) {
    final now = DateTime.now();

    for (var p in prayers) {
      final time = _toDateTime(p.time);
      if (now.isBefore(time)) {
        return p.name;
      }
    }

    // لو خلص اليوم كله → أول صلاة بكرة (الفجر)
    return prayers.first.name;
  }

  static String getNextPrayerTime(List prayers) {
    final now = DateTime.now();

    for (var p in prayers) {
      final time = _toDateTime(p.time);
      if (now.isBefore(time)) {
        return p.time;
      }
    }

    return prayers.first.time;
  }

  static String getRemainingTime(List prayers) {
    final now = DateTime.now();

    for (var p in prayers) {
      final time = _toDateTime(p.time);

      if (now.isBefore(time)) {
        final diff = time.difference(now);

        final hours = diff.inHours;
        final minutes = diff.inMinutes % 60;

        return "$hours ساعة و $minutes دقيقة";
      }
    }

    // لو مفيش صلاة باقيه اليوم → لحد فجر بكرة
    final tomorrowFajr = _toDateTime(prayers.first.time)
        .add(const Duration(days: 1));

    final diff = tomorrowFajr.difference(now);

    return "${diff.inHours} ساعة و ${diff.inMinutes % 60} دقيقة";
  }

  static DateTime _toDateTime(String time) {
    final now = DateTime.now();

    // دعم 12h format (AM/PM)
    if (time.contains("AM") || time.contains("PM")) {
      final isPM = time.contains("PM");

      final clean = time.replaceAll("AM", "").replaceAll("PM", "").trim();
      final parts = clean.split(':');

      int hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      if (isPM && hour != 12) hour += 12;
      if (!isPM && hour == 12) hour = 0;

      return DateTime(now.year, now.month, now.day, hour, minute);
    }

    // 24h format fallback
    final parts = time.split(':');

    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }
}