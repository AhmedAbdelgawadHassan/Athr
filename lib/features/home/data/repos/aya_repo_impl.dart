import 'dart:convert';

import 'package:athr/features/home/data/models/ayaModel.dart';
import 'package:athr/features/home/data/repos/aya_repo.dart';
import 'package:flutter/services.dart';

class AyahRepoImpl implements AyahRepo {
  @override
  Future<List<AyahModel>> getAyahs() async{
    final jsonString = await rootBundle.loadString('assets/data/ayahs.json');  /// load json

    final List data = jsonDecode(jsonString);   // decode json to list

    return data.map((e) => AyahModel.fromJson(e)).toList();  // convert List  to List of AyahModel 
  }

}