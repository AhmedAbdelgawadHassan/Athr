// Improved PrayerTimeContainer UI (clean, elegant, minimal)
// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:athr/core/utils/app_colors.dart';
import 'package:athr/core/utils/app_styles.dart';
import 'package:athr/core/widgets/custom_text_error.dart';
import 'package:athr/core/widgets/prayer_item_shimmer.dart';
import 'package:athr/features/home/data/models/prayer_time_item_model.dart';
import 'package:athr/features/home/presentation/manager/cubits/prayer_time_cubit.dart/prayer_time_cubit.dart';
import 'package:athr/features/home/presentation/manager/cubits/prayer_time_cubit.dart/prayer_time_states.dart';
import 'package:athr/features/home/presentation/views/widgets/prayer_time_item.dart';
import 'package:athr/features/splash/presentation/views/widgets/custom_linear_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class PrayerTimeContainer extends StatefulWidget {
  const PrayerTimeContainer({super.key});

  @override
  State<PrayerTimeContainer> createState() => _PrayerTimeContainerState();
}

class _PrayerTimeContainerState extends State<PrayerTimeContainer> {
  late Timer _clockTimer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  String formatTo12Hour(String time) {
    final parts = time.split(':');
    if (parts.length < 2) return time;

    int hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1];

    String period = hour >= 12 ? 'م' : 'ص';

    hour = hour % 12;
    if (hour == 0) hour = 12;

    return '$hour:$minute $period';
  }

  DateTime? _parsePrayerTimeToday(String time) {
    final parts = time.split(':');
    if (parts.length < 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return DateTime(_now.year, _now.month, _now.day, hour, minute);
  }

  _NextPrayerInfo? _getNextPrayer(List<PrayerTimeItemModel> prayers) {
    if (prayers.isEmpty) return null;

    for (var i = 0; i < prayers.length; i++) {
      final parsed = _parsePrayerTimeToday(prayers[i].time);
      if (parsed == null) continue;

      if (_now.isBefore(parsed)) {
        final prevIndex = i == 0 ? prayers.length - 1 : i - 1;
        final prevParsed = _parsePrayerTimeToday(prayers[prevIndex].time);

        final previousTime = prevIndex == prayers.length - 1
            ? (prevParsed ?? parsed).subtract(const Duration(days: 1))
            : (prevParsed ?? parsed.subtract(const Duration(hours: 1)));

        return _NextPrayerInfo(
          name: prayers[i].name,
          time: prayers[i].time,
          nextTime: parsed,
          previousTime: previousTime,
        );
      }
    }

    final first = prayers.first;
    final firstParsed = _parsePrayerTimeToday(first.time);
    if (firstParsed == null) return null;

    final prev = prayers.last;
    final prevParsed = _parsePrayerTimeToday(prev.time);

    return _NextPrayerInfo(
      name: first.name,
      time: first.time,
      nextTime: firstParsed.add(const Duration(days: 1)),
      previousTime:
          prevParsed ?? firstParsed.subtract(const Duration(hours: 1)),
    );
  }

  String _formatRemaining(Duration remaining) {
    if (remaining.inSeconds <= 0) return 'الآن';
    final h = remaining.inHours;
    final m = remaining.inMinutes.remainder(60);
    if (h > 0 && m > 0) return 'بعد $h ساعة و $m دقيقة';
    if (h > 0) return 'بعد $h ساعة';
    return 'بعد $m دقيقة';
  }

  double _progressBetween(DateTime prev, DateTime next) {
    final total = next.difference(prev).inSeconds;
    if (total <= 0) return 0;
    final passed = _now.difference(prev).inSeconds;
    return (passed / total).clamp(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          BlocBuilder<PrayerTimeCubit, PrayerTimeStates>(
            builder: (context, state) {
              String title = '--';
              String time = '--:--';
              String remaining = 'جاري التحديث...';
              double progress = 0;

              if (state is SuccessPrayerTimeState) {
                final info = _getNextPrayer(state.prayerTimeItemModels);
                if (info != null) {
                  title = 'صلاة ${info.name}';
                  time = info.time;
                  remaining = _formatRemaining(info.nextTime.difference(_now));
                  progress = _progressBetween(info.previousTime, info.nextTime);
                }
              }

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor.withOpacity(0.08),
                          AppColors.primaryColor.withOpacity(0.03),
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryColor.withOpacity(0.2),
                          ),
                          child: Icon(
                            FontAwesomeIcons.clock.data,
                            color: AppColors.primaryColor,
                            size: 18,
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'الصلاة القادمة',
                                style: AppStyles.styleRegular12(context)
                                    .copyWith(color: Colors.grey.shade600),
                              ),
                              const Gap(6),
                              Text(
                                title,
                                style: AppStyles.styleMedium24(context),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              formatTo12Hour(time),
                              style: AppStyles.styleMedium24(context)
                                  .copyWith(color: AppColors.primaryColor),
                            ),
                            const Gap(6),
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const Gap(4),
                                Text(
                                  remaining,
                                  style: AppStyles.styleRegular12(context)
                                      .copyWith(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Gap(18),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Customlinearprogressindicator(
                      padding: 8,
                      height: 6,
                      value: progress,
                    ),
                  ),
                ],
              );
            },
          ),

          const Gap(20),

          Divider(
            thickness: 0.7,
            color: Colors.grey.withOpacity(0.3),
          ),

          const Gap(14),

          BlocBuilder<PrayerTimeCubit, PrayerTimeStates>(
            builder: (context, state) {
              if (state is SuccessPrayerTimeState) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    state.prayerTimeItemModels.length,
                    (i) => PrayerTimeItem(
                      prayerTimeItemModel: state.prayerTimeItemModels[i],
                    ),
                  ),
                );
              }

              if (state is LoadingPrayerTimeState ||
                  state is InitialPrayerTimeState) {
                return const PrayerItemShimmer();
              }

              if (state is FailurePrayerTimeState) {
                return Center(
                  child: CustomTextError(
                    errorMessage: state.errorMessage.toString(),
                  ),
                );
              }

              return const Center(
                child: CustomTextError(errorMessage: 'unknown error'),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _NextPrayerInfo {
  final String name;
  final String time;
  final DateTime nextTime;
  final DateTime previousTime;

  _NextPrayerInfo({
    required this.name,
    required this.time,
    required this.nextTime,
    required this.previousTime,
  });
}
