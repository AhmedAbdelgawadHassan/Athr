// ignore_for_file: deprecated_member_use

import 'package:athr/core/utils/app_colors.dart';
import 'package:athr/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class AddReminderButton extends StatelessWidget {
  const AddReminderButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FaIcon(
                  FontAwesomeIcons.circlePlus,
                  color: Colors.white,
                  size: 20,
                ),
                const Gap(10),
                Text(
                  'إضافة تذكير جديد',
                  style: AppStyles.styleMedium16(context).copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}