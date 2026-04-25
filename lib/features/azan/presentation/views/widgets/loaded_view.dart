  import 'package:athr/features/azan/presentation/manager/cubits/adhan_cubit.dart';
import 'package:athr/features/azan/presentation/manager/cubits/adhan_state.dart';
import 'package:athr/features/azan/presentation/views/widgets/header.dart';
import 'package:athr/features/azan/presentation/views/widgets/prayer_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget loadedView(BuildContext context, AdhanLoaded state) {
    final cubit = context.read<AdhanCubit>();
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: Header(state: state)),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final prayer = state.prayers[index];
              final isNext = index == state.nextPrayerIndex;
              return PrayerCard(
                prayer: prayer,
                isNext: isNext,
                progress: isNext ? state.progress : 0,
                onToggle: () => cubit.togglePrayer(prayer.nameEn),
              );
            },
            childCount: state.prayers.length,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }