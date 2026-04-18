import 'package:athr/features/home/data/models/ayaModel.dart';

abstract class AyahState {}

class AyahLoading extends AyahState {}

class AyahSuccess extends AyahState {
  final AyahModel ayah;

  AyahSuccess(this.ayah);
}

class AyahError extends AyahState {
  final String message;

  AyahError(this.message);
}