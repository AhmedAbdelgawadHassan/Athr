import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('ar')) {
    loadSavedLanguage();
  }

  void changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);

    emit(Locale(languageCode));
  }

  void loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();

    String? code = prefs.getString('languageCode');

    if (code != null) {
      emit(Locale(code));
    }
  }
}