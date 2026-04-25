class PrayerModel {
  final String name;       // اسم الصلاة بالعربي
  final String nameEn;     // اسم الصلاة بالإنجليزي (للصورة والـ key)
  final String time;       // الوقت "HH:mm"
  final String imagePath;  // مسار الصورة
  bool isEnabled;          // هل الأذان مفعّل لهذه الصلاة؟

  PrayerModel({
    required this.name,
    required this.nameEn,
    required this.time,
    required this.imagePath,
    this.isEnabled = true,
  });

  // نحوّل الوقت "HH:mm" لـ DateTime عشان نقدر نقارنه
  DateTime get timeAsDateTime {
    final now = DateTime.now();
    final parts = time.split(':');
    return DateTime(
      now.year, now.month, now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  // نسخة معدّلة من الـ model
  PrayerModel copyWith({bool? isEnabled}) {
    return PrayerModel(
      name: name,
      nameEn: nameEn,
      time: time,
      imagePath: imagePath,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
