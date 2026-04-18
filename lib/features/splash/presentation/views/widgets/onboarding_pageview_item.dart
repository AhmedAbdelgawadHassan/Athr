import 'package:athr/core/utils/app_assets.dart';
import 'package:athr/core/utils/app_styles.dart';
import 'package:athr/core/widgets/header_item.dart';
import 'package:athr/features/splash/data/onboarding_model.dart';
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
        HeaderItem(icone: onboardingModel.icon, color: onboardingModel.color),
        const Gap(30),
        Text(onboardingModel.title, style: AppStyles.styleMedium36(context)),
        const Gap(10),
        Image(image: AssetImage(AppAssets.shadow)),
        const Gap(15),
        Text(
          onboardingModel.subtitle,
          textAlign: TextAlign.center,
          style: AppStyles.styleRegular18(context,).copyWith(color: Colors.black.withValues(alpha: 0.5)),
        ),
      ],
    );
  }
}
