import 'package:athr/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class CustomTextError extends StatelessWidget {
  const CustomTextError({super.key, required this.errorMessage});
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Text(
      errorMessage,
      style:AppStyles.styleMedium18(context).copyWith(color: Colors.red),
    );
  }
}