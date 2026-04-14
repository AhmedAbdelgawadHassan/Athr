import 'package:athr/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class Customlinearprogressindicator extends StatelessWidget {
  const Customlinearprogressindicator({
    super.key,
    required this.padding,
    this.height,
    this.value,
  });
  final double padding;
  final double? height;
  final double? value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: LinearProgressIndicator(
        backgroundColor: Colors.white,
        value: value,
        minHeight: height ?? 3,
        color: AppColors.primaryColor,
      ),
    );
  }
}
