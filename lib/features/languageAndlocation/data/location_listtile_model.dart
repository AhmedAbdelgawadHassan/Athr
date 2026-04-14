import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LocationListtileModel {
  final String title;
  final String subtitle;
  final IconData icon;

  LocationListtileModel({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

 static  final List<LocationListtileModel> locationListtilemodels = [
    LocationListtileModel(
      title: 'أوقات الصلاة الدقيقة',
      subtitle: 'حساب دقيق بناءً على موقعك',
      icon: Icons.location_on_outlined,
    ),
    LocationListtileModel(
      title: 'المساجد القريبة',
      subtitle: 'اكتشف المساجد من حولك',
      icon: FontAwesomeIcons.locationArrow.data,
    ),
    LocationListtileModel(
      title: 'خصوصية محمية',
      subtitle: 'بياناتك آمنة ومحمية',
      icon: Icons.security,
    ),
  ];
}
