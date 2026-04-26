// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:athr/features/quranKarim/presentation/manager/sura_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


// ─── Model ────────────────────────────────────────────────────────────────────

class AyahQuranModel {
  final int numberInSurah;
  final String text;

  const AyahQuranModel({required this.numberInSurah, required this.text});

  factory AyahQuranModel.fromJson(Map<String, dynamic> json) => AyahQuranModel(
        numberInSurah: json['numberInSurah'] as int,
        text: json['text'] as String,
      );

  Map<String, dynamic> toJson() => {
        'numberInSurah': numberInSurah,
        'text': text,
      };
}

// ─── Cubit ────────────────────────────────────────────────────────────────────

class SurahCubit extends Cubit<SurahState> {
  SurahCubit() : super(SurahInitial());

  static const String _cachePrefix = 'surah_cache_';

  Future<void> loadSurah(int surahNumber) async {
    emit(SurahLoading());

    // 1️⃣ Try cache first (offline-first)
    final cached = await _loadFromCache(surahNumber);
    if (cached != null) {
      emit(SurahLoaded(ayahs: cached, fromCache: true));
      return;
    }

    // 2️⃣ Fetch from network
    try {
      final url = Uri.parse(
        'https://api.alquran.cloud/v1/surah/$surahNumber/ar.alafasy',
      );
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final ayahsJson = data['data']['ayahs'] as List;
        final ayahs = ayahsJson.map((e) => AyahQuranModel.fromJson(e)).toList();

        // 3️⃣ Save to cache for offline use
        await _saveToCache(surahNumber, ayahs);

        emit(SurahLoaded(ayahs: ayahs, ));
      } else {
        emit(SurahError('فشل تحميل السورة. كود الخطأ: ${response.statusCode}'));
      }
    } catch (e) {
      emit(SurahError('لا يوجد اتصال بالإنترنت ولم يتم تخزين هذه السورة مسبقاً'));
    }
  }

  Future<List<AyahQuranModel>?> _loadFromCache(int surahNumber) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString('$_cachePrefix$surahNumber');
      if (jsonStr == null) return null;
      final list = jsonDecode(jsonStr) as List;
      return list.map((e) => AyahQuranModel.fromJson(e)).toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveToCache(int surahNumber, List<AyahQuranModel> ayahs) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(ayahs.map((e) => e.toJson()).toList());
      await prefs.setString('$_cachePrefix$surahNumber', jsonStr);
    } catch (_) {}
  }

  Future<bool> isCached(int surahNumber) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('$_cachePrefix$surahNumber');
  }
}