import 'package:athr/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.onPressed,
      required this.text,
      required this.buttonColor,
      required this.textColor,
      required this.borderColor});
  final VoidCallback onPressed;
  final String text;
  final Color buttonColor;
  final Color textColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16),
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: borderColor, width: 1),
              borderRadius: BorderRadius.circular(16))),
      onPressed: onPressed,
      child: Text(
        text,
        style: AppStyles.styleMedium16(context).copyWith(
          color: textColor,
        ),
      ),
    );
  }
}
