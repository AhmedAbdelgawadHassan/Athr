import 'package:athr/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OnboardingModel {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  OnboardingModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });



  static  final List<OnboardingModel> onboardingItemList = [
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

}


