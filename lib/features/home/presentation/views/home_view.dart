// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:athr/core/services/location_service.dart';
import 'package:athr/core/utils/app_colors.dart';
import 'package:athr/features/azkar/presentation/view/azkar_view.dart';
import 'package:athr/features/home/data/models/home_item_model.dart';
import 'package:athr/features/home/data/repos/aya_repo_impl.dart';
import 'package:athr/features/home/presentation/manager/cubits/aya_cubit/aya_cubit.dart';
import 'package:athr/features/home/presentation/manager/cubits/prayer_time_cubit.dart/prayer_time_cubit.dart';
import 'package:athr/features/home/presentation/views/widgets/home_item.dart';
import 'package:athr/features/home/presentation/views/widgets/home_top_section.dart';
import 'package:athr/features/home/presentation/views/widgets/today_aya_container.dart';
import 'package:athr/features/quranKarim/presentation/views/quran_view.dart';
import 'package:athr/features/reminder/presentation/manager/cubits/reminder_cubit.dart';
import 'package:athr/features/reminder/presentation/views/reminder_view.dart';
import 'package:athr/features/tasbeeh/presentation/views/tasbeeh_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future<void> _loadLocation() async {
    final location = await LocationService.getLocation();
    if (location != null && mounted) {
      context.read<PrayerTimeCubit>().getPrayerTime(
            latitude: location.latitude,
            longitude: location.longitude,
          );
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // "استنى لما الشاشة تترسم الأول، وبعد كده نفّذ الكود اللي جوه"
      // this method is called after the first frame is built and displayed on the screen
      _loadLocation(); // load data after the first screen is displayed
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final overlapOffset = screenHeight * 0.22;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  const HomeTopSection(),
                  Positioned(
                    bottom: -overlapOffset,
                    left: 15,
                    right: 15,
                    child: BlocProvider(
                      create: (context) =>
                          AyahCubit(AyahRepoImpl())..getTodayAyah(),

                      /// call getTodayAyah() method
                      child: TodayAyaContainer(),
                    ),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(top: overlapOffset + 20),
              sliver: SliverToBoxAdapter(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: HomeItem(
                                homeItemModel: HomeItemModel(
                                  title: 'القرآن الكريم',
                                  subtitle: 'قراءة القرآن الكريم',
                                  icon: FontAwesomeIcons.bookQuran.data,
                                  color: AppColors.primaryColor,
                                  buildNavigationScreen: () =>
                                      const QuranView(),
                                ),
                              ),
                            ),
                            Gap(20),
                            Expanded(
                              child: HomeItem(
                                homeItemModel: HomeItemModel(
                                  title: 'الأذان',
                                  subtitle: 'مواقيت الصلاة',
                                  icon: FontAwesomeIcons.clock.data,
                                  color: AppColors.secondaryColor,
                                  buildNavigationScreen: () =>
                                      const SizedBox.shrink(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(20),
                        Row(
                          children: [
                            Expanded(
                              child: HomeItem(
                                homeItemModel: HomeItemModel(
                                  title: 'الأدعية والأذكار',
                                  subtitle: 'حصن المسلم',
                                  icon: FontAwesomeIcons.hand.data,
                                  color: AppColors.secondaryColor,
                                  buildNavigationScreen: () =>
                                      const AzkarView()
                                ),
                              ),
                            ),
                            Gap(20),
                            Expanded(
                              child: HomeItem(
                                homeItemModel: HomeItemModel(
                                  title: 'التذكيرات',
                                  subtitle: 'تنبيهات يومية',
                                  icon: Icons.notifications_outlined,
                                  color: AppColors.primaryColor,
                                  buildNavigationScreen: () => BlocProvider(
                                      create: (context) => ReminderCubit(),
                                      child: const ReminderView()),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(20),
                        Row(
                          children: [
                            Expanded(
                              child: HomeItem(
                                homeItemModel: HomeItemModel(
                                  title: 'تعليم القرآن',
                                  subtitle: 'دروس وتلاوات',
                                  icon: FontAwesomeIcons.headphones.data,
                                  color: AppColors.primaryColor,
                                  buildNavigationScreen: () =>
                                      const SizedBox.shrink(),
                                ),
                              ),
                            ),
                            Gap(20),
                            Expanded(
                              child: HomeItem(
                                homeItemModel: HomeItemModel(
                                  title: 'المساجد',
                                  subtitle: 'أقرب المساجد',
                                  icon: Icons.location_on_outlined,
                                  color: AppColors.secondaryColor,
                                  buildNavigationScreen: () =>
                                      const SizedBox.shrink(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(20),
                        Row(
                          children: [
                            Expanded(
                              child: HomeItem(
                                homeItemModel: HomeItemModel(
                                  title: 'المسبحة',
                                  subtitle: 'عداد التسبيح',
                                  icon: FontAwesomeIcons.circle.data,
                                  color: AppColors.secondaryColor,
                                  buildNavigationScreen: () =>
                                      const TasbeehView(),
                                ),
                              ),
                            ),
                            Gap(20),
                            Expanded(
                              child: HomeItem(
                                homeItemModel: HomeItemModel(
                                  title: 'اتجاه القبلة',
                                  subtitle: 'تحديد اتجاه القبلة',
                                  icon: FontAwesomeIcons.compass.data,
                                  color: AppColors.primaryColor,
                                  buildNavigationScreen: () =>
                                      const SizedBox.shrink(),
                                ),
                              ),
                            ),
                            Gap(20),
                          ],
                        )
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
