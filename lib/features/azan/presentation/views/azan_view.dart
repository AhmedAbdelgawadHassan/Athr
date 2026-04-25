// ignore_for_file: deprecated_member_use, avoid_print
import 'package:athr/features/azan/presentation/views/widgets/error_view.dart';
import 'package:athr/features/azan/presentation/views/widgets/loaded_view.dart';
import 'package:athr/features/azan/presentation/views/widgets/loading_view.dart';
import 'package:athr/features/azan/presentation/views/widgets/show_adhan_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athr/features/azan/presentation/manager/cubits/adhan_cubit.dart';
import 'package:athr/features/azan/presentation/manager/cubits/adhan_state.dart';
import 'package:athr/features/home/presentation/manager/cubits/prayer_time_cubit.dart/prayer_time_cubit.dart';
import 'package:athr/features/home/presentation/manager/cubits/prayer_time_cubit.dart/prayer_time_states.dart';

class AzanView extends StatefulWidget {
  const AzanView({super.key});

  @override
  State<AzanView> createState() => _AzanViewState();
}

class _AzanViewState extends State<AzanView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {   // this method is called after the first frame is built and displayed on the screen
      _tryLoadAdhan();   // this method is responsible for loading the data of the prayers
    });
  }

  void _tryLoadAdhan() {
    /// get the current state of the PrayerTimeCubit
    final prayerState = context.read<PrayerTimeCubit>().state;

   /// if the data is correctly loaded, load it into the AdhanCubit
    if (prayerState is SuccessPrayerTimeState) {
      context.read<AdhanCubit>().loadPrayers(prayerState.prayerTimeItemModels); 
    }
    // لو لسه loading → الـ BlocListener تحت هيمسك لما تجي
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F3),
      body: SafeArea(
        child: BlocListener<PrayerTimeCubit, PrayerTimeStates>(

          listener: (context, prayerState) {
            if (prayerState is SuccessPrayerTimeState) {
              context
                  .read<AdhanCubit>()
                  .loadPrayers(prayerState.prayerTimeItemModels);
            }
          },
          child: BlocConsumer<AdhanCubit, AdhanState>(
            listener: (context, state) {
                print('👂 listener fired, state: $state');
              if (state is AdhanLoaded && state.activeAdhanPrayer != null) {
                    print('🕌 showing banner: ${state.activeAdhanPrayer}');

                showAdhanBanner(context, state.activeAdhanPrayer!);
              }
            },
            builder: (context, state) {
              if (state is AdhanLoading) return loadingView();
              if (state is AdhanError) return errorView(state.message);
              if (state is AdhanLoaded) return loadedView(context, state);
              return loadingView();
            },
          ),
        ),
      ),



      );
  }
  }

