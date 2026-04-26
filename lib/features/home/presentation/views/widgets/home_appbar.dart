// ignore_for_file: deprecated_member_use

import 'package:athr/core/utils/app_colors.dart';
import 'package:athr/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeAppbar extends StatelessWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // TEXT SECTION
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'تطبيق أثر',
                style: AppStyles.styleMedium30(context).copyWith(
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const Gap(6),
              Text(
                'حيث تتحول النوايا إلى أعمال خالدة',
                style: AppStyles.styleRegular14(context).copyWith(
                  color: Colors.white.withOpacity(0.75),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        // ICON (Islamic touch)
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.12),
          ),
          child:  Icon(
            Icons.star, // هلال
            color: AppColors.gold,
            size: 22,
          ),
        ),
      ],
    );
  }
}