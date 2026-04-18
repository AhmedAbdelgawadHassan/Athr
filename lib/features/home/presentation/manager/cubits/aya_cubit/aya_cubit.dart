import 'package:athr/features/home/data/repos/aya_repo.dart';
import 'package:athr/features/home/presentation/manager/cubits/aya_cubit/aya_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AyahCubit extends Cubit<AyahState> {
  AyahCubit(this.repo) : super(AyahLoading());

  final AyahRepo repo;

  Future<void> getTodayAyah() async {
    try {
      final ayahs = await repo.getAyahs();

      final now = DateTime.now();
      final start = DateTime(now.year, 1, 1);
      final index = now.difference(start).inDays;

      emit(AyahSuccess(ayahs[index % ayahs.length]));
    } catch (e) {
      emit(AyahError(e.toString()));
    }
  }
}