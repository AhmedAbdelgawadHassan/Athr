import 'package:athr/features/home/data/models/ayaModel.dart';

abstract class AyahRepo {
  Future<List<AyahModel>> getAyahs();   /// Method to get JSON data from assets and convert it to List of AyahModel and return it
  
}