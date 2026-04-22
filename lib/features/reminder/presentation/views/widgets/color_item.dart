import 'package:athr/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ColorItem extends StatelessWidget {
  const ColorItem({super.key, required this.color,  this.isSelected=false});
    final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return  AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border:  Border.all(color: AppColors.primaryColor, width:  isSelected?2:0),
            color: color,
          ));
  }
}