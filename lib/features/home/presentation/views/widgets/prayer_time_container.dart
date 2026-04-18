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
      // update time every 30 seconds
      if (!mounted) return;
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();

    /// cancel timer
    super.dispose();
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
      final prayer = prayers[i];
      final parsed = _parsePrayerTimeToday(prayer.time);
      if (parsed == null) continue;

      if (_now.isBefore(parsed)) {
        // check if current time is before parsed time
        final previousIndex = i == 0 ? prayers.length - 1 : i - 1;
        final previousParsed = _parsePrayerTimeToday(
          prayers[previousIndex].time,
        );
        final previousTime = previousIndex == prayers.length - 1
            ? (previousParsed ?? parsed).subtract(const Duration(days: 1))
            : (previousParsed ?? parsed.subtract(const Duration(hours: 1)));

        return _NextPrayerInfo(
          name: prayer.name,
          time: prayer.time,
          nextTime: parsed,
          previousTime: previousTime,
        );
      }
    }

    final firstPrayer = prayers.first;
    final firstParsed = _parsePrayerTimeToday(firstPrayer.time);
    if (firstParsed == null) return null;
    final prevPrayer = prayers.last;
    final prevParsed = _parsePrayerTimeToday(prevPrayer.time);

    return _NextPrayerInfo(
      name: firstPrayer.name,
      time: firstPrayer.time,
      nextTime: firstParsed.add(const Duration(days: 1)),
      previousTime:
          prevParsed ?? firstParsed.subtract(const Duration(hours: 1)),
    );
  }

  String _formatRemaining(Duration remaining) {
    if (remaining.inSeconds <= 0) return 'الآن';
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);
    if (hours > 0 && minutes > 0) return 'بعد $hours ساعة و $minutes دقيقة';
    if (hours > 0) return 'بعد $hours ساعة';
    return 'بعد $minutes دقيقة';
  }

  double _progressBetween(DateTime previous, DateTime next) {
    final total = next.difference(previous).inSeconds;
    if (total <= 0) return 0;
    final passed = _now.difference(previous).inSeconds;
    return (passed / total).clamp(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          BlocBuilder<PrayerTimeCubit, PrayerTimeStates>(
            builder: (context, state) {
              String title = '--';
              String time = '--:--';
              String remainingText = 'جاري التحديث...';
              double progressValue = 0;

              if (state is SuccessPrayerTimeState) {
                final info = _getNextPrayer(state.prayerTimeItemModels);
                if (info != null) {
                  title = 'صلاة ${info.name}';
                  time = info.time;
                  remainingText = _formatRemaining(
                    info.nextTime.difference(_now),
                  );
                  progressValue = _progressBetween(
                    info.previousTime,
                    info.nextTime,
                  );
                } else {
                  remainingText = 'تعذر حساب الصلاة القادمة';
                }
              } else if (state is FailurePrayerTimeState) {
                remainingText = state.errorMessage;
              }

              return Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor,
                        ),
                        child: Icon(
                          FontAwesomeIcons.clock.data,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      const Gap(10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'الصلاة القادمة',
                            style: AppStyles.styleRegular12(
                              context,
                            ).copyWith(color: Color(0xff6B6B6B)),
                          ),
                          const Gap(5),
                          Text(title, style: AppStyles.styleMedium24(context)),
                        ],
                      ),
                      Spacer(),
                      Column(
                        children: [
                          Text(
                            time,
                            style: AppStyles.styleMedium30(
                              context,
                            ).copyWith(color: AppColors.primaryColor),
                          ),
                          const Gap(5),
                          Row(
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withValues(
                                    alpha: 0.6,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Gap(5),
                              Text(
                                remainingText,
                                style: AppStyles.styleRegular12(
                                  context,
                                ).copyWith(color: Color(0xff6B6B6B)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Gap(30),
                  Customlinearprogressindicator(
                    padding: 20,
                    height: 4,
                    value: progressValue,
                  ),
                ],
              );
            },
          ),
          const Gap(30),
          Divider(
            thickness: 1,
            color: Colors.grey.withValues(alpha: 0.5),
            indent: 20,
            endIndent: 20,
          ),
          const Gap(12),
          BlocBuilder<PrayerTimeCubit, PrayerTimeStates>(
            builder: (context, state) {
              if (state is SuccessPrayerTimeState) {
                return SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: state.prayerTimeItemModels.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: PrayerTimeItem(
                          prayerTimeItemModel:
                              state.prayerTimeItemModels[index],
                        ),
                      );
                    },
                  ),
                );
              } else if (state is InitialPrayerTimeState) {
                return const PrayerItemShimmer();
              } else if (state is FailurePrayerTimeState) {
                return Center(
                  child: CustomTextError(
                    errorMessage: state.errorMessage.toString(),
                  ),
                );
              } else if (state is LoadingPrayerTimeState) {
                return const PrayerItemShimmer();
              } else {
                return const Center(
                  child: CustomTextError(errorMessage: 'unknown error'),
                );
              }
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
