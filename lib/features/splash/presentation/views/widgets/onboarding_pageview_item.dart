import 'package:athr/core/utils/app_assets.dart';
import 'package:athr/core/utils/app_styles.dart';
import 'package:athr/features/splash/data/onboardind_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OnboardingPageviewItem extends StatelessWidget {
  const OnboardingPageviewItem({super.key, required this.onboardingModel});
  final OnboardingModel onboardingModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          decoration: BoxDecoration(
            color: onboardingModel.color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(onboardingModel.icon, color: Colors.white, size: 35),
        ),

        const Gap(30),
        Text(onboardingModel.title, style: AppStyles.styleMedium36(context)),
        const Gap(12),
        Image(image: AssetImage(AppAssets.shadow)),
        const Gap(20),
        Text(
          onboardingModel.subtitle,
          textAlign: TextAlign.center,
          style: AppStyles.styleRegular18(
            context,
          ).copyWith(color: Colors.black.withOpacity(0.5)),
        ),
      ],
    );
  }
}
