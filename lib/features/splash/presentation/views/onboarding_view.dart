// ignore_for_file: deprecated_member_use

import 'package:athr/constants.dart';
import 'package:athr/core/functions/circle_drawer.dart';
import 'package:athr/core/services/shared_prefrence.dart';
import 'package:athr/core/utils/app_colors.dart';
import 'package:athr/features/languageAndlocation/presentation/view/language_view.dart';
import 'package:athr/features/splash/data/onboarding_model.dart';
import 'package:athr/features/splash/presentation/views/widgets/dots_indicator.dart';
import 'package:athr/features/splash/presentation/views/widgets/last_button.dart';
import 'package:athr/features/splash/presentation/views/widgets/next_button.dart';
import 'package:athr/features/splash/presentation/views/widgets/onboarding_pageview_item.dart';
import 'package:athr/features/splash/presentation/views/widgets/skip_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  int currentIndex = 0;
  final PageController pageController = PageController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -200,
              right: -190,
              child: drawCircle(
                radius: 200,
                borderColor: Colors.grey.withOpacity(0.1),
                backgroundColor: Colors.transparent,
                borderWidth: 5,
              ),
            ),
            Positioned(
              bottom: -200,
              left: -190,
              child: drawCircle(
                radius: 200,
                borderColor: Colors.grey.withOpacity(0.1),
                backgroundColor: Colors.transparent,
                borderWidth: 5,
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 10,
              right: 10,
              child: drawCircle(
                radius: 100,
                borderColor: Colors.grey.withOpacity(0.1),
                backgroundColor: Colors.transparent,
                borderWidth: 5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Spacer(),
                  AspectRatio(
                    aspectRatio: 1.2,
                    child: PageView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      controller: pageController,
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      itemCount:OnboardingModel.onboardingItemList.length,
                      itemBuilder: (context, index) {
                        return OnboardingPageviewItem(
                          onboardingModel:   OnboardingModel.onboardingItemList[index],
                        );
                      },
                    ),
                  ),
                  Gap(20),
                  DotsIndicator(currentIndex: currentIndex),
                  Spacer(),
                  Row(
                    children: [
                      Skipbutton(
                        onPressed: () {
                          Prefs.setBool(kIsOnboardingSeen, true); 
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LanguageView(),
                            ),
                          );
                        },
                      ),
                      const Spacer(),
                      currentIndex == 0
                          ? SizedBox()
                          : Lastbutton(
                              onPressed: () {
                                pageController.previousPage(
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeIn,
                                );
                              },
                            ),
                      Nextbutton(
                        text: currentIndex == 2 ? 'أبدا الأن' : 'التالي',
                        color: currentIndex == 1
                            ? AppColors.secondaryColor
                            : AppColors.primaryColor,
                        onPressed: () {
                          currentIndex == 2 
                              ? {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LanguageView(),
                                 ) ),
                                 Prefs.setBool(kIsOnboardingSeen, true)
                              }
                                 : pageController.nextPage(
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeIn,
                                );
                        
                        },
                      ),
                    ],
                  ),
                  Gap(10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
