import 'dart:async';
import 'package:athr/core/services/prayer_scheduler_service.dart';
import 'package:athr/features/azan/data/models/prayer_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:athr/features/home/data/models/prayer_time_item_model.dart';
import 'adhan_state.dart';

class _Images {
  static const fagr   = 'assets/images/fagr.png';
  static const dohr   = 'assets/images/dohr.png';
  static const asr    = 'assets/images/asr.png';
  static const magreb = 'assets/images/magreb.png';
  static const eshaa  = 'assets/images/eshaa.png';
}

class AdhanCubit extends Cubit<AdhanState> {
  Timer? _uiTimer;

  AdhanCubit() : super(AdhanLoading());

  Future<void> loadPrayers(List<PrayerTimeItemModel> apiPrayers) async {
    emit(AdhanLoading());
    try {
      final prayers = [
        PrayerModel(name: 'الفجر',  nameEn: 'Fajr',    time: apiPrayers[0].time, imagePath: _Images.fagr,   isEnabled: await _loadEnabled('Fajr')),
        PrayerModel(name: 'الظهر',  nameEn: 'Dhuhr',   time: apiPrayers[1].time, imagePath: _Images.dohr,   isEnabled: await _loadEnabled('Dhuhr')),
        PrayerModel(name: 'العصر',  nameEn: 'Asr',     time: apiPrayers[2].time, imagePath: _Images.asr,    isEnabled: await _loadEnabled('Asr')),
        PrayerModel(name: 'المغرب', nameEn: 'Maghrib', time: apiPrayers[3].time, imagePath: _Images.magreb, isEnabled: await _loadEnabled('Maghrib')),
        PrayerModel(name: 'العشاء', nameEn: 'Isha',    time: apiPrayers[4].time, imagePath: _Images.eshaa,  isEnabled: await _loadEnabled('Isha')),
      ];

      await PrayerSchedulerService.instance.scheduleTodayPrayers(prayers);

      _startUiTimer(prayers);
      _emitLoaded(prayers);
    } catch (e) {
      emit(AdhanError('حدث خطأ أثناء تحميل المواقيت: $e'));
    }
  }

  Future<void> togglePrayer(String prayerNameEn) async {
    final currentState = state;
    if (currentState is! AdhanLoaded) return;

    final updatedPrayers = currentState.prayers.map((p) {
      if (p.nameEn == prayerNameEn) return p.copyWith(isEnabled: !p.isEnabled);
      return p;
    }).toList();

    final changed = updatedPrayers.firstWhere((p) => p.nameEn == prayerNameEn);
    await _saveEnabled(prayerNameEn, changed.isEnabled);
    await PrayerSchedulerService.instance.reschedulePrayer(changed);

    emit(currentState.copyWith(prayers: updatedPrayers));
  }

  void _emitLoaded(List<PrayerModel> prayers, {String? activeAdhan}) {
    final now = DateTime.now();
    int nextIndex = prayers.indexWhere((p) => p.timeAsDateTime.isAfter(now));
    if (nextIndex == -1) nextIndex = 0;

    final nextPrayer = prayers[nextIndex];
    var nextTime = nextPrayer.timeAsDateTime;
    if (nextIndex == 0 && nextTime.isBefore(now)) {
      nextTime = nextTime.add(const Duration(days: 1));
    }

    final timeToNext = nextTime.difference(now);
    double progress = 0;
    if (nextIndex > 0) {
      final prevTime = prayers[nextIndex - 1].timeAsDateTime;
      final totalDiff = nextTime.difference(prevTime).inMinutes;
      final elapsed = now.difference(prevTime).inMinutes;
      progress = (elapsed / totalDiff).clamp(0.0, 1.0);
    }

    emit(AdhanLoaded(
      prayers: prayers,
      nextPrayerIndex: nextIndex,
      timeToNextPrayer: timeToNext,
      progress: progress,
      activeAdhanPrayer: activeAdhan,
    ));
  }

  void _startUiTimer(List<PrayerModel> prayers) {
    _uiTimer?.cancel();
    _uiTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      final currentState = state;
      if (currentState is AdhanLoaded) _emitLoaded(currentState.prayers);
    });
  }

  Future<bool> _loadEnabled(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('adhan_$key') ?? true;
  }

  Future<void> _saveEnabled(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('adhan_$key', value);
  }

  @override
  Future<void> close() {
    _uiTimer?.cancel();
    return super.close();
  }
}