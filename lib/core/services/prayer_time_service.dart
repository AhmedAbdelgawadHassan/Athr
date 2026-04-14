import 'package:athr/core/errors/failures.dart';
import 'package:athr/features/home/data/models/prayer_time_item_model.dart';
import 'package:dio/dio.dart';

class PrayerTimeService {
  final Dio dio;
  PrayerTimeService({required this.dio});

  Future<List<PrayerTimeItemModel>> getPrayerTime({
     required double latitude,
    required double longitude,
  }) async {
    final String baseUrl = 'https://api.aladhan.com/v1';

    try {
  final Response response = await dio.get(
    '$baseUrl/timings?latitude=$latitude&longitude=$longitude&method=3',
  );
  return PrayerTimeItemModel.fromApi(response.data);
} on DioException catch (e) {
  throw ServerFailure.fromDioException(e);
} on Exception catch (e) {
  throw ServerFailure(errorMessage: e.toString()) ;
  }}
}
