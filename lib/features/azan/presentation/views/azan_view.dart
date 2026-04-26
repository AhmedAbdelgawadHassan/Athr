// lib/features/azan/presentation/views/azan_view.dart
// ignore_for_file: deprecated_member_use, avoid_print
import 'package:athr/features/azan/presentation/views/widgets/error_view.dart';
import 'package:athr/features/azan/presentation/views/widgets/loaded_view.dart';
import 'package:athr/features/azan/presentation/views/widgets/loading_view.dart';
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
  // نحتفظ بـ reference للـ cubit عشان نستخدمه في البانر بأمان
  late final AdhanCubit _adhanCubit;

  @override
  void initState() {
    super.initState();
    _adhanCubit = context.read<AdhanCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tryLoadAdhan();
    });
  }

  void _tryLoadAdhan() {
    final prayerState = context.read<PrayerTimeCubit>().state;
    debugPrint('🔍 PrayerState: ${prayerState.runtimeType}');
    if (prayerState is SuccessPrayerTimeState) {
      debugPrint('✅ Calling loadPrayers');
      _adhanCubit.loadPrayers(prayerState.prayerTimeItemModels);
    }
  }

  void _showAdhanBanner(String prayerName) {
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);

    messenger.showMaterialBanner(
      MaterialBanner(
        backgroundColor: const Color(0xFF1B6B45),
        padding: const EdgeInsets.all(16),
        content: Text(
          'حان وقت $prayerName 🕌',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: const Icon(Icons.mosque_rounded, color: Colors.white),
        actions: [
          TextButton(
            onPressed: () {
              messenger.hideCurrentMaterialBanner();
              // نستخدم الـ reference المحفوظة مش context.read
              _adhanCubit.stopAdhan();
            },
            child: const Text(
              '🔇 إيقاف الأذان',
              style: TextStyle(color: Color(0xFFD4AF37)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F3),
      body: SafeArea(
        child: BlocListener<PrayerTimeCubit, PrayerTimeStates>(
          listener: (context, prayerState) {
            if (prayerState is SuccessPrayerTimeState) {
              _adhanCubit.loadPrayers(prayerState.prayerTimeItemModels);
            }
          },
          child: BlocConsumer<AdhanCubit, AdhanState>(
            listener: (context, state) {
              if (state is AdhanLoaded) {
                if (state.activeAdhanPrayer != null) {
                  _showAdhanBanner(state.activeAdhanPrayer!);
                } else {
                  // الأذان وقف → أخفي البانر
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                }
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