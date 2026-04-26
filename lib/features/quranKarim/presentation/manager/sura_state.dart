

import 'package:athr/features/quranKarim/presentation/manager/sura_cubit.dart';

abstract class SurahState {}

class SurahInitial extends SurahState {}

class SurahLoading extends SurahState {}

class SurahLoaded extends SurahState {
  final List<AyahQuranModel> ayahs;
  final bool fromCache;
  SurahLoaded({required this.ayahs, this.fromCache = false});
}

class SurahError extends SurahState {
  final String message;
  SurahError(this.message);
}