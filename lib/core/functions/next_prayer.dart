class PrayerHelper {
  static String getNextPrayerName(List prayers) {
    final now = DateTime.now();

    for (var p in prayers) {
      final time = _toDateTime(p.time);
      if (now.isBefore(time)) {
        return p.name;
      }
    }
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
        return "${diff.inHours} ساعة و ${diff.inMinutes % 60} دقيقة";
      }
    }
    return "";
  }

  static DateTime _toDateTime(String time) {
    final now = DateTime.now();
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