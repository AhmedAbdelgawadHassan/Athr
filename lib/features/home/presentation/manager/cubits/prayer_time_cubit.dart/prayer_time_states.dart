import 'package:athr/features/home/data/models/prayer_time_item_model.dart';

abstract class PrayerTimeStates {}

class InitialPrayerTimeState extends PrayerTimeStates {}
class LoadingPrayerTimeState extends PrayerTimeStates {}
class SuccessPrayerTimeState extends PrayerTimeStates {
  final List<PrayerTimeItemModel> prayerTimeItemModels;

  SuccessPrayerTimeState({required this.prayerTimeItemModels});
}

class FailurePrayerTimeState extends PrayerTimeStates {
  final String errorMessage;

  FailurePrayerTimeState({required this.errorMessage});
}