// ignore_for_file: deprecated_member_use, curly_braces_in_flow_control_structures
import 'dart:math';
import 'package:athr/core/utils/app_colors.dart';
import 'package:flutter/material.dart';


// ── رسام السهم الكبير ─────────────────────────────────────────
class ArrowPainter extends CustomPainter {
  final Color color;
  const ArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final arrowPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final headPath = Path()
      ..moveTo(cx, cy - 46)
      ..lineTo(cx - 18, cy - 10)
      ..lineTo(cx + 18, cy - 10)
      ..close();

    final bodyPath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy + 14), width: 10, height: 44),
        const Radius.circular(5),
      ));

    final tailPaint = Paint()
      ..color = color.withOpacity(0.35)
      ..style = PaintingStyle.fill;

    final tailPath = Path()
      ..moveTo(cx, cy + 46)
      ..lineTo(cx - 14, cy + 16)
      ..lineTo(cx + 14, cy + 16)
      ..close();

    canvas.drawPath(headPath, shadowPaint);
    canvas.drawPath(tailPath, tailPaint);
    canvas.drawPath(bodyPath, arrowPaint);
    canvas.drawPath(headPath, arrowPaint);
  }

  @override
  bool shouldRepaint(covariant ArrowPainter old) => old.color != color;
}

// ── رسام البوصلة الاحتياطي ────────────────────────────────────
class FallbackCompassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = size.width / 2;

    final circlePaint = Paint()
      ..color = AppColors.gold.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset(cx, cy), radius - 4, circlePaint);

    final tickPaint = Paint()
      ..color = AppColors.gold.withOpacity(0.5)
      ..strokeWidth = 1.5;

    for (int i = 0; i < 12; i++) {
      final angle = i * (2 * pi / 12);
      final outerX = cx + (radius - 6) * sin(angle);
      final outerY = cy - (radius - 6) * cos(angle);
      final innerX = cx + (radius - 16) * sin(angle);
      final innerY = cy - (radius - 16) * cos(angle);
      canvas.drawLine(Offset(outerX, outerY), Offset(innerX, innerY), tickPaint);
    }

    final northPaint = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.fill;
    final northPath = Path()
      ..moveTo(cx, cy - radius + 20)
      ..lineTo(cx - 8, cy)
      ..lineTo(cx + 8, cy)
      ..close();
    canvas.drawPath(northPath, northPaint);

    final southPaint = Paint()
      ..color = AppColors.textSecondary.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    final southPath = Path()
      ..moveTo(cx, cy + radius - 20)
      ..lineTo(cx - 8, cy)
      ..lineTo(cx + 8, cy)
      ..close();
    canvas.drawPath(southPath, southPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── رسام الزخارف الإسلامية ────────────────────────────────────
class IslamicPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final topGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFD4AF6A).withOpacity(0.18),
          Colors.transparent,
        ],
        radius: 0.7,
      ).createShader(Rect.fromCircle(
        center: Offset(size.width / 2, 0),
        radius: size.height * 0.5,
      ));
    canvas.drawCircle(Offset(size.width / 2, 0), size.height * 0.5, topGlow);

    final dotPaint = Paint()
      ..color = AppColors.gold.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    const spacing = 28.0;
    for (double x = 0; x < size.width; x += spacing)
      for (double y = 0; y < size.height; y += spacing)
        canvas.drawCircle(Offset(x, y), 1.2, dotPaint);

    final linePaint = Paint()
      ..color = AppColors.gold.withOpacity(0.15)
      ..strokeWidth = 0.5;
    canvas.drawLine(
      Offset(size.width * 0.1, 100),
      Offset(size.width * 0.9, 100),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
