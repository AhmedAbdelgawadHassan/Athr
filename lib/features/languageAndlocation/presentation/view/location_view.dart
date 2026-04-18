// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:athr/constants.dart';
import 'package:athr/core/functions/circle_drawer.dart';
import 'package:athr/core/services/location_service.dart';
import 'package:athr/core/services/shared_prefrence.dart';
import 'package:athr/core/utils/app_colors.dart';
import 'package:athr/core/utils/app_styles.dart';
import 'package:athr/core/widgets/header_item.dart';
import 'package:athr/features/home/presentation/manager/cubits/prayer_time_cubit.dart/prayer_time_cubit.dart';
import 'package:athr/features/home/presentation/manager/cubits/prayer_time_cubit.dart/prayer_time_states.dart';
import 'package:athr/features/home/presentation/views/home_view.dart';
import 'package:athr/features/languageAndlocation/data/location_listtile_model.dart';
import 'package:athr/features/languageAndlocation/presentation/view/widget/location_listtile.dart';
import 'package:athr/features/languageAndlocation/presentation/view/widget/location_permition_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class LocationView extends StatefulWidget {
  const LocationView({super.key});

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<PrayerTimeCubit, PrayerTimeStates>(
      listener: (context, state) {
        if (state is SuccessPrayerTimeState) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeView()),
          );

          Prefs.setBool(kIsOnboardingSeen, true);
        }

        if (state is FailurePrayerTimeState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -250,
                  right: -190,
                  child: drawCircle(
                    radius: 170,
                    borderColor: Colors.grey.withOpacity(0.08),
                    backgroundColor: const Color(0xffF5F4F1),
                    borderWidth: 5,
                  ),
                ),
                Positioned(
                  bottom: -250,
                  left: -190,
                  child: drawCircle(
                    radius: 200,
                    borderColor: Colors.grey.withOpacity(0.08),
                    backgroundColor: const Color(0xffF5F4F1),
                    borderWidth: 5,
                  ),
                ),

                Column(
                  children: [
                    const Gap(20),
                    HeaderItem(
                      icone: Icons.location_on_outlined,
                      color: AppColors.primaryColor,
                    ),
                    const Gap(10),
                    Text(
                      'تحديد الموقع',
                      style: AppStyles.styleMedium30(context),
                    ),

                    const Gap(5),

                    Text(
                      'نحتاج إلى موقعك لحساب أوقات الصلاة الدقيقة في منطقتك وإظهار المساجد القريبة منك',
                      textAlign: TextAlign.center,
                      style: AppStyles.styleRegular16(
                        context,
                      ).copyWith(color: const Color(0xff6B6B6B)),
                    ),
                    const Gap(20),
                    Expanded(
                      child: ListView.builder(
                        itemCount:
                            LocationListtileModel.locationListtilemodels.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            child: LocationListtile(
                              locationListtilemodel: LocationListtileModel
                                  .locationListtilemodels[index],
                            ),
                          );
                        },
                      ),
                    ),
                    LocationPermitionButton(
                      onPressed: () async {
                        Prefs.setBool(kIsOnboardingSeen, true);
                        final location = await LocationService.getLocation();
                        if (location != null) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => HomeView()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "لم يتم تحديد الموقع",
                                style: AppStyles.styleMedium18(context),
                              ),
                            ),
                          );
                        }
                      },
                    ),

                    const Gap(10),
                    TextButton(
                      onPressed: () {
                        Prefs.setBool(kIsOnboardingSeen, true);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeView()),
                        );
                      },
                      child: Text(
                        'تخطي الأن',
                        style: AppStyles.styleMedium16(
                          context,
                        ).copyWith(color: const Color(0xff6B6B6B)),
                      ),
                    ),

                    Text(
                      'يمكنك تغيير هذا الإعداد لاحقًا من الإعدادات',
                      style: AppStyles.styleRegular12(
                        context,
                      ).copyWith(color: const Color(0xff6B6B6B)),
                    ),

                    const Gap(20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
