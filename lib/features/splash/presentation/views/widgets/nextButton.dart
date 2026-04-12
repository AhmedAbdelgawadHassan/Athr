import 'package:athr/core/utils/app_assets.dart';
import 'package:athr/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Nextbutton extends StatelessWidget {
  const Nextbutton({super.key, required this.onPressed, required this.color, required this.text});
  final VoidCallback onPressed;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
           Text(
            text,
            style: AppStyles.styleMedium16(
              context,
            ).copyWith(color: Colors.white),
          ),
           const Gap(10),
        Image.asset(AppAssets.arrow),
         
         
        ],
      ),
    );
  }
}
