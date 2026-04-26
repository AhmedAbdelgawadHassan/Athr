// ignore_for_file: deprecated_member_use

import 'package:athr/features/quranKarim/presentation/views/surah_details_view.dart';
import 'package:flutter/widgets.dart';

class MushafBorderPainter extends CustomPainter {
  const MushafBorderPainter({required this.accentColor});
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final outerPaint = Paint()
      ..color = accentColor.withOpacity(0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final innerPaint = Paint()
      ..color = accentColor.withOpacity(0.30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final cornerPaint = Paint()
      ..color = accentColor.withOpacity(0.65)
      ..style = PaintingStyle.fill;

    const r = 8.0;   // corner radius
    const m = 3.0;   // margin between outer and inner frame
    const c = 18.0;  // corner ornament size

    // ── الإطار الخارجي ────────────────────────────────────────────────────
    final outerRect = RRect.fromLTRBR(
      0, 0, size.width, size.height,
      const Radius.circular(r),
    );
    canvas.drawRRect(outerRect, outerPaint);

    // ── الإطار الداخلي ────────────────────────────────────────────────────
    final innerRect = RRect.fromLTRBR(
      m, m, size.width - m, size.height - m,
      const Radius.circular(r - 1),
    );
    canvas.drawRRect(innerRect, innerPaint);

    // ── زخارف الزوايا ────────────────────────────────────────────────────
    _drawCornerOrnament(canvas, cornerPaint, accentColor,
        Offset(0, 0), c, CornerType.topLeft);
    _drawCornerOrnament(canvas, cornerPaint, accentColor,
        Offset(size.width, 0), c, CornerType.topRight);
    _drawCornerOrnament(canvas, cornerPaint, accentColor,
        Offset(0, size.height), c, CornerType.bottomLeft);
    _drawCornerOrnament(canvas, cornerPaint, accentColor,
        Offset(size.width, size.height), c, CornerType.bottomRight);

    // ── زخارف منتصف الجوانب ───────────────────────────────────────────────
    _drawSideMidOrnament(canvas, accentColor,
        Offset(size.width / 2, 0));                  // أعلى
    _drawSideMidOrnament(canvas, accentColor,
        Offset(size.width / 2, size.height));         // أسفل
    _drawSideMidOrnamentV(canvas, accentColor,
        Offset(0, size.height / 2));                  // يسار
    _drawSideMidOrnamentV(canvas, accentColor,
        Offset(size.width, size.height / 2));         // يمين
  }

  void _drawCornerOrnament(
    Canvas canvas,
    Paint fill,
    Color color,
    Offset corner,
    double size,
    CornerType type,
  ) {
    final linePaint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    double dx = 0, dy = 0;
    switch (type) {
      case CornerType.topLeft:
        dx = 1; dy = 1;
        break;
      case CornerType.topRight:
        dx = -1; dy = 1;
        break;
      case CornerType.bottomLeft:
        dx = 1; dy = -1;
        break;
      case CornerType.bottomRight:
        dx = -1; dy = -1;
        break;
    }

    // خطان متعامدان
    canvas.drawLine(
      corner,
      corner + Offset(dx * size, 0),
      linePaint,
    );
    canvas.drawLine(
      corner,
      corner + Offset(0, dy * size),
      linePaint,
    );

    // نقطة الزاوية
    canvas.drawCircle(corner + Offset(dx * 2, dy * 2), 3.5, fill);

    // نقطتان صغيرتان على الخطين
    final dotPaint = Paint()
      ..color = color.withOpacity(0.4)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(corner + Offset(dx * size * 0.5, dy * 1.5), 2, dotPaint);
    canvas.drawCircle(corner + Offset(dx * 1.5, dy * size * 0.5), 2, dotPaint);
  }

  void _drawSideMidOrnament(Canvas canvas, Color color, Offset center) {
    final paint = Paint()
      ..color = color.withOpacity(0.55)
      ..style = PaintingStyle.fill;
    // مثلث صغير للأعلى/الأسفل
    final path = Path();
    path.moveTo(center.dx, center.dy);
    path.lineTo(center.dx - 6, center.dy + 6);
    path.lineTo(center.dx + 6, center.dy + 6);
    path.close();
    canvas.drawPath(path, paint);
    canvas.drawCircle(center, 3, paint);
  }

  void _drawSideMidOrnamentV(Canvas canvas, Color color, Offset center) {
    final paint = Paint()
      ..color = color.withOpacity(0.55)
      ..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(center.dx, center.dy);
    path.lineTo(center.dx + 6, center.dy - 6);
    path.lineTo(center.dx + 6, center.dy + 6);
    path.close();
    canvas.drawPath(path, paint);
    canvas.drawCircle(center, 3, paint);
  }

  @override
  bool shouldRepaint(MushafBorderPainter old) =>
      old.accentColor != accentColor;
}