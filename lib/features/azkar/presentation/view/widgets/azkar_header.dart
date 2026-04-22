// ignore_for_file: deprecated_member_use

import 'package:athr/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AzkarHeader extends StatelessWidget {
  const AzkarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0F2027),
            Color(0xFF203A43),
            Color(0xFF2C5364),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.auto_awesome,
            color: Colors.white,
            size: 30,
          ),
        Gap(20),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Text(
                  "اذكر الله يطمئن قلبك 🤍",
                  style: AppStyles.styleMedium20(context).copyWith(
                    color: Colors.white,
                  )
                ),
               Gap(6),
                Text(
                  "اجعل لسانك رطباً بذكر الله في كل وقت",
                  style:AppStyles.styleMedium12(context).copyWith(
                     color: Colors.white70,
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}