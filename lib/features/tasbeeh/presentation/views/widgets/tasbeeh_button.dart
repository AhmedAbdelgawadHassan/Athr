import 'package:athr/core/utils/app_colors.dart';
import 'package:athr/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TasbeehButton extends StatelessWidget {
  const TasbeehButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
    
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(40),
        backgroundColor: AppColors.primaryColor,
        shape: CircleBorder()),
      onPressed: onTap,
      child:   Column(
          children: [
            Text(
              "تسبيح",
              style:AppStyles.styleMedium18(context).copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )
            ),
             Gap(5),
             Text(
              "اضغط للعد",
              style: AppStyles.styleRegular12(context).copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
            ),)
            
          ],
        ),
    );
  }
}