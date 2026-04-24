// ignore_for_file: deprecated_member_use
import 'package:athr/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import '../painters/painters.dart';

class BigArrowWidget extends StatelessWidget {
  final bool isAligned;
  final Animation<double> pulseAnimation;
  final AnimationController rotationController;
  final Animation<double> rotationAnimation;

  const BigArrowWidget({
    super.key,
    required this.isAligned,
    required this.pulseAnimation,
    required this.rotationController,
    required this.rotationAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final color = isAligned ? AppColors.teal : AppColors.gold;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // هالة خلف السهم
          AnimatedBuilder(
            animation: pulseAnimation,
            builder: (_, __) => Transform.scale(
              scale: isAligned ? pulseAnimation.value : 1.0,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [color.withOpacity(0.15), Colors.transparent],
                  ),
                ),
              ),
            ),
          ),

          // حلقة خارجية
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.3), width: 1.5),
              color: AppColors.bgCard.withOpacity(0.6),
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.12), blurRadius: 20, spreadRadius: 4),
                BoxShadow(color: AppColors.shadowColor, blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
          ),

          // السهم المتحرك
          AnimatedBuilder(
            animation: rotationController,
            builder: (_, __) => Transform.rotate(
              angle: rotationAnimation.value,
              child: SizedBox(
                width: 120,
                height: 120,
                child: CustomPaint(painter: ArrowPainter(color: color)),
              ),
            ),
          ),

          // نقطة المركز
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8)],
            ),
          ),
        ],
      ),
    );
  }
}
