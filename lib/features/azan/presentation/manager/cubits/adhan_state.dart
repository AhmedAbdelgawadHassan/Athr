import '../../../data/models/prayer_model.dart';

abstract class AdhanState {}

// حالة التحميل الأولي
class AdhanLoading extends AdhanState {}

// حالة الخطأ
class AdhanError extends AdhanState {
  final String message;
  AdhanError(this.message);
}

// الحالة الرئيسية — فيها كل البيانات اللي الـ UI محتاجها
class AdhanLoaded extends AdhanState {
  final List<PrayerModel> prayers; // قائمة الصلوات الـ 5
  final int nextPrayerIndex; // index الصلاة الجاية
  final Duration timeToNextPrayer; // الوقت المتبقي للصلاة الجاية
  final double progress; // نسبة الوقت المتبقي (للـ progress bar)
  final String? activeAdhanPrayer; // اسم الصلاة اللي بيشتغل أذانها دلوقتي

  AdhanLoaded({
    required this.prayers,
    required this.nextPrayerIndex,
    required this.timeToNextPrayer,
    required this.progress,
    this.activeAdhanPrayer,
  });

  // ✅ FIX: استخدمنا sentinel عشان نقدر نبعت null بشكل صريح
  static const _absent = Object();

  AdhanLoaded copyWith({
    List<PrayerModel>? prayers,
    int? nextPrayerIndex,
    Duration? timeToNextPrayer,
    double? progress,
    Object? activeAdhanPrayer = _absent, // لو مش متبعت → يفضل القديم
  }) {
    return AdhanLoaded(
      prayers: prayers ?? this.prayers,
      nextPrayerIndex: nextPrayerIndex ?? this.nextPrayerIndex,
      timeToNextPrayer: timeToNextPrayer ?? this.timeToNextPrayer,
      progress: progress ?? this.progress,
      // لو اتبعت قيمة (حتى null) → استخدمها، غير كده → فضل القديم
      activeAdhanPrayer: activeAdhanPrayer == _absent
          ? this.activeAdhanPrayer
          : activeAdhanPrayer as String?,
    );
  }
}
