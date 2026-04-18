import 'package:athr/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('ar')) {  // default language
    loadSavedLanguage();
  }

  void changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kLanguageCode, languageCode);

    emit(Locale(languageCode));
  }

  void loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();

    String? code = prefs.getString(kLanguageCode);

    if (code != null) {
      emit(Locale(code));
    }
  }
}