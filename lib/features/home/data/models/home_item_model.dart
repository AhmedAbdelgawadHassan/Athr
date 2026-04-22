import 'package:flutter/material.dart';

class HomeItemModel {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget Function() buildNavigationScreen;

  HomeItemModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.buildNavigationScreen,
  });

}