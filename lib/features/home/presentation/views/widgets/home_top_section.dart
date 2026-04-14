import 'package:athr/core/utils/app_colors.dart';
import 'package:athr/features/home/presentation/views/widgets/home_appbar.dart';
import 'package:athr/features/home/presentation/views/widgets/prayer_time_container.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeTopSection extends StatelessWidget {
  const HomeTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50),bottomRight: Radius.circular(50)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeAppbar(),
                  const Gap(20),
                  PrayerTimeContainer(),
                  const Gap(50),
                ],
              )
    );
  }
}