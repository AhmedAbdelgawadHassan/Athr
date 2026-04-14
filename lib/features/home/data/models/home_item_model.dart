import 'package:athr/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeItemModel {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  HomeItemModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });



  /// Home Item Models
  static List<HomeItemModel> homeItemModels = [
    HomeItemModel(
      title: 'القرآن الكريم',
      subtitle: 'قراءة القرآن الكريم',
      icon: FontAwesomeIcons.bookQuran.data,
      color: AppColors.primaryColor,
      onTap: () {},
    ),
    HomeItemModel(
      title: 'الأذان',
      subtitle: 'مواقيت الصلاة',
      icon: FontAwesomeIcons.clock.data,
      color: AppColors.secondaryColor,
      onTap: () {},
    ),
    HomeItemModel(
      title: 'الأدعية والأذكار',
      subtitle: 'حصن المسلم',
      icon: FontAwesomeIcons.hand.data,
      color: AppColors.secondaryColor,
      onTap: (){},
    ),
     HomeItemModel(
      title: 'التذكيرات',
      subtitle: 'تنبيهات يومية',
      icon: Icons.notifications_outlined,
      color: AppColors.primaryColor,
      onTap: (){},
    ),
     HomeItemModel(
      title: 'تعليم القرآن',
      subtitle: 'دروس وتلاوات',
      icon: FontAwesomeIcons.headphones.data,
      color: AppColors.primaryColor,
      onTap: (){},
    ),
     HomeItemModel(
      title: 'المساجد',
      subtitle: 'أقرب المساجد',
      icon: Icons.location_on_outlined,
      color: AppColors.secondaryColor,
      onTap: (){},
    ),
     HomeItemModel(
      title: 'المسبحة',
      subtitle: 'عداد التسبيح',
      icon: FontAwesomeIcons.circle.data,
      color: AppColors.secondaryColor,
      onTap: (){},
    ),
     HomeItemModel(
      title: 'اتجاه القبلة',
      subtitle: 'تحديد اتجاه القبلة',
      icon: FontAwesomeIcons.compass.data,
      color: AppColors.primaryColor,
      onTap: (){},
    ),
  
  ];
}
