import 'package:athr/core/utils/app_colors.dart';
import 'package:athr/features/quranKarim/presentation/views/quran.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeItemModel {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget navigationScreen;

  HomeItemModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.navigationScreen,
  });



  /// Home Item Models
  static List<HomeItemModel> homeItemModels = [
    HomeItemModel(
      title: 'القرآن الكريم',
      subtitle: 'قراءة القرآن الكريم',
      icon: FontAwesomeIcons.bookQuran.data,
      color: AppColors.primaryColor,
      navigationScreen: QuranView()
    ),
    HomeItemModel(
      title: 'الأذان',
      subtitle: 'مواقيت الصلاة',
      icon: FontAwesomeIcons.clock.data,
      color: AppColors.secondaryColor,
      navigationScreen: SizedBox()
    ),
    HomeItemModel(
      title: 'الأدعية والأذكار',
      subtitle: 'حصن المسلم',
      icon: FontAwesomeIcons.hand.data,
      color: AppColors.secondaryColor,
      navigationScreen: SizedBox()
    ),
     HomeItemModel(
      title: 'التذكيرات',
      subtitle: 'تنبيهات يومية',
      icon: Icons.notifications_outlined,
      color: AppColors.primaryColor,
       navigationScreen: SizedBox()
    ),
     HomeItemModel(
      title: 'تعليم القرآن',
      subtitle: 'دروس وتلاوات',
      icon: FontAwesomeIcons.headphones.data,
      color: AppColors.primaryColor,
       navigationScreen: SizedBox()
      
    ),
     HomeItemModel(
      title: 'المساجد',
      subtitle: 'أقرب المساجد',
      icon: Icons.location_on_outlined,
      color: AppColors.secondaryColor,
       navigationScreen: SizedBox()
    ),
     HomeItemModel(
      title: 'المسبحة',
      subtitle: 'عداد التسبيح',
      icon: FontAwesomeIcons.circle.data,
      color: AppColors.secondaryColor,
       navigationScreen: SizedBox()
    ),
     HomeItemModel(
      title: 'اتجاه القبلة',
      subtitle: 'تحديد اتجاه القبلة',
      icon: FontAwesomeIcons.compass.data,
      color: AppColors.primaryColor,
      navigationScreen: SizedBox()
    ),
  
  ];
}
