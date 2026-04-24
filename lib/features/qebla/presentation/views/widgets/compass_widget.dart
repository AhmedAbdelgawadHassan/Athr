// ignore_for_file: deprecated_member_use
import 'dart:math';
import 'package:athr/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import '../painters/painters.dart';

class CompassWidget extends StatelessWidget {
  final double compassAngle;
  final bool isAligned;

  const CompassWidget({
    super.key,
    required this.compassAngle,
    required this.isAligned,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 220,
        height: 220,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // هالة
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    (isAligned ? AppColors.teal : AppColors.gold).withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            // الحلقة الخارجية
            Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gold.withOpacity(0.3), width: 1),
              ),
            ),

            // نقاط الاتجاهات
            ..._compassPoints(),

            // صورة البوصلة
            Transform.rotate(
              angle: compassAngle,
              child: Image.asset(
                'assets/compass.png',
                width: 185,
                height: 185,
                color: Colors.black.withOpacity(0.75),
                colorBlendMode: BlendMode.modulate,
                errorBuilder: (context, error, stackTrace) => SizedBox(
                  width: 185,
                  height: 185,
                  child: CustomPaint(painter: FallbackCompassPainter()),
                ),
              ),
            ),

            // نقطة المركز
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gold,
                boxShadow: [BoxShadow(color: AppColors.gold.withOpacity(0.5), blurRadius: 6)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _compassPoints() {
    const dirs = [
      ('ش', 0.0),
      ('ج', pi),
      ('غ', -pi / 2),
      ('ش.ق', pi / 2),
    ];
    const radius = 92.0;
    const center = 110.0;

    return dirs.map((d) {
      final label = d.$1;
      final angle = d.$2;
      final x = center + radius * sin(angle);
      final y = center - radius * cos(angle);
      final isNorth = label == 'ش' && angle == 0.0;

      return Positioned(
        left: x - 14,
        top: y - 12,
        child: Text(
          label,
          style: TextStyle(
            color: isNorth ? AppColors.gold : AppColors.textSecondary,
            fontSize: isNorth ? 13 : 10,
            fontWeight: isNorth ? FontWeight.w900 : FontWeight.w500,
          ),
        ),
      );
    }).toList();
  }
}
