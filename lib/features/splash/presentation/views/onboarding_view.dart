// ignore_for_file: deprecated_member_use

import 'package:athr/constants.dart';
import 'package:athr/core/functions/circle_drawer.dart';
import 'package:athr/core/services/shared_prefrence.dart';
import 'package:athr/core/utils/app_colors.dart';
import 'package:athr/features/language&location/presentation/view/language_view.dart';
import 'package:athr/features/splash/data/onboardind_model.dart';
import 'package:athr/features/splash/presentation/views/widgets/dots_indicator.dart';
import 'package:athr/features/splash/presentation/views/widgets/lastButton.dart';
import 'package:athr/features/splash/presentation/views/widgets/nextButton.dart';
import 'package:athr/features/splash/presentation/views/widgets/onboarding_pageview_item.dart';
import 'package:athr/features/splash/presentation/views/widgets/skipButton.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  int currentIndex = 0;
  final PageController pageController = PageController();
  final List<OnboardingModel> onboardingItemList = [
    OnboardingModel(
      title: 'القرآن الكريم',
      subtitle:
          'اقرأ القرآن الكريم بخط واضح وتصميم جميل مع إمكانية الاستماع للتلاوات',
      icon: FontAwesomeIcons.bookQuran.data,
      color: AppColors.primaryColor,
    ),
    OnboardingModel(
      title: 'مواقيت الصلاة',
      subtitle: 'تنبيهات دقيقة لمواقيت الصلاة حسب موقعك مع صوت الأذان',
      icon: FontAwesomeIcons.clock.data,
      color: AppColors.secondaryColor,
    ),
    OnboardingModel(
      title: 'رفيقك الروحاني',
      subtitle: 'تذكيرات يومية، أذكار، تسبيح، وكل ما تحتاجه في رحلتك الإيمانية',
      icon: FontAwesomeIcons.heart.data,
      color: AppColors.primaryColor,
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -200,
              right: -190,
              child: drawCircle(
                radius: 200,
                borderColor: Colors.grey.withOpacity(0.05),
                backgroundColor: Colors.white,
                borderWidth: 5,
              ),
            ),
            Positioned(
              bottom: -200,
              left: -190,
              child: drawCircle(
                radius: 200,
                borderColor: Colors.grey.withOpacity(0.05),
                backgroundColor: Colors.white,
                borderWidth: 5,
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 35,
              right: 35,
              child: drawCircle(
                radius: 100,
                borderColor: Colors.grey.withOpacity(0.05),
                backgroundColor: Colors.white,
                borderWidth: 5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  AspectRatio(
                    aspectRatio: 1.4,
                    child: PageView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      controller: pageController,
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      itemCount: onboardingItemList.length,
                      itemBuilder: (context, index) {
                        return OnboardingPageviewItem(
                          onboardingModel: onboardingItemList[index],
                        );
                      },
                    ),
                  ),
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
                                  duration: Duration(milliseconds: 300),
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
                                  duration: Duration(milliseconds: 300),
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
