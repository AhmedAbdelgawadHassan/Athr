import 'package:athr/core/errors/failures.dart';
import 'package:athr/features/home/data/models/prayer_time_item_model.dart';
import 'package:dartz/dartz.dart';

abstract class PrayerTimeRepo {
 Future<Either<Failures, List<PrayerTimeItemModel>>> getPrayerTime({required double latitude, required double longitude});

}