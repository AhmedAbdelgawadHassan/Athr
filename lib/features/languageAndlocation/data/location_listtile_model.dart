import 'package:flutter/material.dart';

class LocationListtileModel {
  final String title;
  final String subtitle;
  final IconData icon;

  LocationListtileModel({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

 static final List<LocationListtileModel> locationListtilemodels = [
  LocationListtileModel(
    title: 'القرآن الكريم',
    subtitle: 'تلاوة، حفظ، واستماع بصوت عذب',
    icon: Icons.menu_book_rounded,
  ),
  LocationListtileModel(
    title: 'السيرة النبوية',
    subtitle: 'تعرف على حياة النبي ﷺ وأحداثها',
    icon: Icons.history_edu_rounded,
  ),
  LocationListtileModel(
    title: 'الأذان وأوقات الصلاة',
    subtitle: 'تنبيهات دقيقة حسب موقعك',
    icon: Icons.notifications_active_outlined,
  ),
  LocationListtileModel(
    title: 'اتجاه القبلة',
    subtitle: 'اعرف اتجاه القبلة أينما كنت',
    icon: Icons.explore_outlined,
  ),
  LocationListtileModel(
    title: 'المسبحة الإلكترونية',
    subtitle: 'سبّح واذكر الله بسهولة',
    icon: Icons.radio_button_checked,
  ),
  LocationListtileModel(
    title: 'الأدعية والأذكار',
    subtitle: 'أذكار الصباح والمساء وأكثر',
    icon: Icons.auto_awesome,
  ),
  LocationListtileModel(
    title: 'التذكيرات اليومية',
    subtitle: 'لا تنسَ وِردك اليومي من العبادة',
    icon: Icons.alarm,
  ),
  LocationListtileModel(
    title: 'اختبر نفسك',
    subtitle: '10 أسئلة يومية دينية للتعلّم',
    icon: Icons.quiz_outlined,
  ),
];
}
