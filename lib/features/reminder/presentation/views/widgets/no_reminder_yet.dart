// ignore_for_file: deprecated_member_use

import 'package:athr/core/utils/app_colors.dart';
import 'package:athr/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class NoRemindersView extends StatelessWidget {
  const NoRemindersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.bellSlash,
              size: 70,
              color: AppColors.primaryColor.withOpacity(0.6),
            ),
            const Gap(20),
            Text(
              'لا يوجد تذكيرات بعد',
              style: AppStyles.styleMedium24(context),
            ),
            const Gap(10),
            Text(
              'ابدأ بإضافة أول تذكير ليصلك تنبيه في الوقت الذي تختاره 🤍',
              textAlign: TextAlign.center,
              style: AppStyles.styleRegular16(context)
                  .copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
