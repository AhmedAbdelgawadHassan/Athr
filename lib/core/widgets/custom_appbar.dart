// ignore_for_file: deprecated_member_use

import 'package:athr/core/functions/circle_drawer.dart';
import 'package:athr/core/utils/app_colors.dart';
import 'package:athr/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key, required this.title, required this.subtitle, this.icon});
  final String title;
  final String subtitle;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[
         Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.primaryColor,
        ),
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
            Gap(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppStyles.styleMedium24(context)
                        .copyWith(color: Colors.white)),
                Gap(5),
                Text(subtitle,
                    style: AppStyles.styleRegular14(context)
                        .copyWith(color: Colors.white.withOpacity(0.7))),
              ],
            ),
            Spacer(),
            Icon(
              icon ,
              color: Colors.white,
              size: 25,
            ),
          ],
        ),
      ),
      Positioned(
          top: -45,
          right: -65,
          child: drawCircle(
              radius: 50,
              borderColor: Colors.grey.withOpacity(0.25),
              borderWidth: 3,
              backgroundColor: Colors.transparent),
        ),
       
       Positioned(
          bottom: -45,
          left: -65,
          child: drawCircle(
              radius: 50,
              borderColor: Colors.grey.withOpacity(0.25),
              borderWidth: 3,
              backgroundColor: Colors.transparent),
        ),
   ] );
  }
}
