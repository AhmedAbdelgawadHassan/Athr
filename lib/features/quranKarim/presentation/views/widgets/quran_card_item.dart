import 'package:athr/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class QuranCardItem extends StatelessWidget {
  const QuranCardItem({super.key, required this.title, required this.icon, required this.value, required this.cardColor, required this.valueColor, required this.iconColor, required this.border});
  final String title ;
  final IconData icon;
  final int value;
  final Color cardColor;
  final Color valueColor;
  final Color iconColor;
  final Color border;


  @override
  Widget build(BuildContext context) {
    return Container(
      width:MediaQuery.of(context).size.width*0.3,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          const Gap(20),
          Icon(icon, color: iconColor, size: 26),
          const Gap(20),
          Text(value.toString(), style: AppStyles.styleRegular18(context).copyWith(color: valueColor)),
          const Gap(20),
          Text(title, style: AppStyles.styleRegular12(context).copyWith(color: Color(0xff6B6B6B))),
          const Gap(20),
        ],
      ),
    );
  }
}