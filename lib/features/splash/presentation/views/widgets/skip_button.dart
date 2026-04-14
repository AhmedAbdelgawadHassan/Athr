import 'package:athr/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class Skipbutton extends StatelessWidget {
  const Skipbutton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        'تخطي',
        style: AppStyles.styleMedium16(context).copyWith(color: Colors.black),
      ),
    );
  }
}
