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
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            // ignore: deprecated_member_use
            side: BorderSide(color: AppColors.secondaryColor.withOpacity(0.4), width: 1.5),
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.plus,
              color: Color(0xff6B6B6B),
              size: 20,
            ),
            Gap(15),
            Text(
              'إضافة تذكير جديد',
              style: AppStyles.styleRegular16(context)
                  .copyWith(color: Color(0xff6B6B6B)),
            )
          ],
        ));
  }
}
