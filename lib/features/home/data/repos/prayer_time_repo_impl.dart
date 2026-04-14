import 'package:athr/core/errors/failures.dart';
import 'package:athr/core/services/prayer_time_service.dart';
import 'package:athr/features/home/data/models/prayer_time_item_model.dart';
import 'package:athr/features/home/data/repos/prayer_time_repo.dart';
import 'package:dartz/dartz.dart';

class PrayerTimeRepoImpl implements PrayerTimeRepo{
  final PrayerTimeService prayerTimeService;

  PrayerTimeRepoImpl({required this.prayerTimeService});
  @override
Future<Either<Failures, List<PrayerTimeItemModel>>> getPrayerTime({
  required double latitude,
  required double longitude,
}) async {
  try {
    final prayers = await prayerTimeService.getPrayerTime(
      latitude: latitude,
      longitude: longitude,
    );
    return Right(prayers);
  } on Failures catch (failure) {
    return Left(failure);
  } catch (e) {
    return Left(
      ServerFailure(
        errorMessage: 'Unexpected error occurred while loading prayer times.',
      ),
    );
  }
}
  }

