import 'package:athr/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class DotsIndicator extends StatelessWidget {
  const DotsIndicator({
    super.key,
    required this.currentIndex,
  });

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedContainer(
          margin: EdgeInsets.symmetric(horizontal: 5),
          duration: const Duration(milliseconds: 300),
          width: currentIndex == index ? 40 : 10,
          height: 9,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? currentIndex == 1
                      ? AppColors.secondaryColor
                      : AppColors.primaryColor
                : Colors.grey.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
    );
  }
}
