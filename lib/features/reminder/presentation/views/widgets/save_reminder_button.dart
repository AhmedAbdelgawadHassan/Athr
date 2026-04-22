// ignore_for_file: deprecated_member_use

import 'package:athr/core/utils/app_colors.dart';
import 'package:athr/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SaveReminderButton extends StatelessWidget {
  const SaveReminderButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
              onPressed: () {
                Navigator.pop(context);
              },
              text: 'إلغاء',
              buttonColor: Colors.white,
              textColor: Colors.black,
              borderColor: Colors.grey.withOpacity(0.5)),
        ),
        const Gap(20),
        Expanded(
          child: CustomButton(
              onPressed: onPressed,
              text: 'حفظ التذكير',
              buttonColor: AppColors.primaryColor,
              textColor: Colors.white,
              borderColor: Colors.transparent),
        ),
      ],
    );
  }
}
