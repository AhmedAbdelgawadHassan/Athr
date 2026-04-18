import 'package:athr/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class DotsIndicator extends StatelessWidget {
  const DotsIndicator({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedContainer(
          margin: EdgeInsets.symmetric(horizontal: 5),
          duration: const Duration(milliseconds: 400),
          width: currentIndex == index ? 40 : 10,
          height: 9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: currentIndex == index
                ? currentIndex == 1
                      ? AppColors.secondaryColor
                      : AppColors.primaryColor
                : Colors.grey.withValues(alpha: 0.55),
            
          ),
        );
      }),
    );
  }
}
