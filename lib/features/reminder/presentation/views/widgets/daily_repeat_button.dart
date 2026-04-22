// ignore_for_file: deprecated_member_use

import 'package:athr/core/utils/app_colors.dart';
import 'package:athr/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class DailyRepeatButton extends StatefulWidget {
  const DailyRepeatButton({super.key, required this.onRepeatChanged});
  final ValueChanged<bool> onRepeatChanged;

  @override
  State<DailyRepeatButton> createState() => _DailyRepeatButtonState();
}

class _DailyRepeatButtonState extends State<DailyRepeatButton> {
  bool isActive = false;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.45),
        borderRadius: BorderRadius.circular(16),
      ),
      child:   Row(
        children: [
          Text('تكرار يومي',style: AppStyles.styleRegular14(context),),
          Spacer(),
          Switch(
               value: isActive,
               onChanged: (value) {
                 setState(() {
                   isActive = value;
                 });
                 widget.onRepeatChanged(value);
               },
               activeThumbColor: AppColors.primaryColor,
               inactiveThumbColor: Colors.grey,
               activeTrackColor: AppColors.primaryColor.withOpacity(0.2),
               inactiveTrackColor: Colors.white,
             ),
        ],
      ),
    );
  }
}