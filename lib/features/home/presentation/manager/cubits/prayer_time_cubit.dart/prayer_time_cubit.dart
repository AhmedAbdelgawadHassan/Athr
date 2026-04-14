
import 'package:athr/features/home/data/repos/prayer_time_repo_impl.dart';
import 'package:athr/features/home/presentation/manager/cubits/prayer_time_cubit.dart/prayer_time_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrayerTimeCubit extends Cubit<PrayerTimeStates> {
  PrayerTimeCubit(super.initialState, {required this.prayerTimeRepo,});
  final PrayerTimeRepoImpl prayerTimeRepo ;


  Future<void> getPrayerTime({required double latitude, required double longitude}) async {
    emit(LoadingPrayerTimeState());
     final result = await prayerTimeRepo.getPrayerTime(latitude: latitude, longitude: longitude);
    return result.fold((failure) {
      emit(FailurePrayerTimeState(errorMessage: failure.errorMessage));
    }, (prayers) {
      emit(SuccessPrayerTimeState(prayerTimeItemModels: prayers));
    },);

  }
}