// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'package:flutter/widgets.dart';

class AyahEndMarker extends StatelessWidget {
  const AyahEndMarker({super.key, required this.number, required this.color});
  final int number;
  final Color color;

  static const _w = ['0','1','2','3','4','5','6','7','8','9'];
  static const _a = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];

  String _toArabic(int n) => n.toString().split('').map((d) {
        final i = _w.indexOf(d);
        return i >= 0 ? _a[i] : d;
      }).join();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 38,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(38, 38),
            painter: _AyahMarkerPainter(color: color),
          ),
          Text(
            _toArabic(number),
            style: TextStyle(
              fontFamily: 'ScheherazadeNew',
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _AyahMarkerPainter extends CustomPainter {
  final Color color;
  const _AyahMarkerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final outerR = size.width / 2;
    final innerR = outerR * 0.55;

    final fillPaint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // ── زخارف خارجية (بتلات) ──
    const petalCount = 16;
    final petalR = outerR * 0.82;
    final petalSize = outerR * 0.22;

    for (int i = 0; i < petalCount; i++) {
      final angle = (2 * pi * i) / petalCount - pi / 2;
      final px = cx + petalR * cos(angle);
      final py = cy + petalR * sin(angle);

      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(angle + pi / 2);

      final petalPath = Path()
        ..moveTo(0, -petalSize * 0.6)
        ..quadraticBezierTo(petalSize * 0.4, -petalSize * 0.1, 0, petalSize * 0.6)
        ..quadraticBezierTo(-petalSize * 0.4, -petalSize * 0.1, 0, -petalSize * 0.6)
        ..close();

      canvas.drawPath(petalPath, fillPaint);
      canvas.drawPath(petalPath, strokePaint);
      canvas.restore();
    }

    // ── النجمة الداخلية (بتلات صغيرة بين الكبار) ──
    const smallCount = 16;
    final smallR = outerR * 0.68;
    final smallSize = outerR * 0.12;

    for (int i = 0; i < smallCount; i++) {
      final angle = (2 * pi * i) / smallCount - pi / 2 + pi / smallCount;
      final px = cx + smallR * cos(angle);
      final py = cy + smallR * sin(angle);

      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(angle + pi / 2);

      final smallPath = Path()
        ..moveTo(0, -smallSize)
        ..quadraticBezierTo(smallSize * 0.35, 0, 0, smallSize)
        ..quadraticBezierTo(-smallSize * 0.35, 0, 0, -smallSize)
        ..close();

      canvas.drawPath(smallPath, fillPaint);
      canvas.drawPath(smallPath, strokePaint);
      canvas.restore();
    }

    // ── الدايرة الداخلية ──
    canvas.drawCircle(
      Offset(cx, cy),
      innerR,
      fillPaint,
    );
    canvas.drawCircle(
      Offset(cx, cy),
      innerR,
      strokePaint,
    );

    // ── دايرة خط رفيع تاني ──
    canvas.drawCircle(
      Offset(cx, cy),
      innerR * 0.85,
      strokePaint..strokeWidth = 0.5,
    );
  }

  @override
  bool shouldRepaint(_AyahMarkerPainter old) => old.color != color;
}