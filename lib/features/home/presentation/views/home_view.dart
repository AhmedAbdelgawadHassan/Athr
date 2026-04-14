import 'package:athr/core/services/location_service.dart';
import 'package:athr/features/home/data/models/home_item_model.dart';
import 'package:athr/features/home/presentation/manager/cubits/prayer_time_cubit.dart/prayer_time_cubit.dart';
import 'package:athr/features/home/presentation/views/widgets/home_item.dart';
import 'package:athr/features/home/presentation/views/widgets/home_top_section.dart';
import 'package:athr/features/home/presentation/views/widgets/today_aya_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
 const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future<void> _loadData() async {
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
    _loadData();
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
                  HomeTopSection(),
                  Positioned(
                    bottom: -overlapOffset,
                    left: 15,
                    right: 15,
                    child: TodayAyaContainer(),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(top: overlapOffset + 10),
              sliver: SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount:  HomeItemModel.homeItemModels.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) =>
                        HomeItem(homeItemModel: HomeItemModel.homeItemModels[index]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
