// ignore_for_file: deprecated_member_use

import 'package:athr/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class IconItem extends StatelessWidget {
  const IconItem({super.key, required this.icon, this.isSelected = false});
  final IconData icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isSelected ? Color.fromARGB(255, 177, 233, 217) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : Colors.grey.withOpacity(0.5),
            width: isSelected ? 2.5 : 1),
      ),
      child: Icon(
        icon,
        color: Colors.black,
        size: 25,
      ),
    );
  }
}
