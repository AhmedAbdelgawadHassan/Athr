import 'package:athr/features/quiz/presentation/view/painters/range_painter.dart';
import 'package:flutter/material.dart';

class ScoreRing extends StatefulWidget {
  final int score;
  final int total;
  final List<Color> gradient;

  const ScoreRing(
      {super.key, required this.score, required this.total, required this.gradient});

  @override
  State<ScoreRing> createState() => ScoreRingState();
}

class ScoreRingState extends State<ScoreRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _anim = Tween<double>(begin: 0, end: widget.score / widget.total)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(
        const Duration(milliseconds: 400), () => mounted ? _ctrl.forward() : null);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => SizedBox(
        width: 160,
        height: 160,
        child: CustomPaint(
          painter: RingPainter(progress: _anim.value, gradient: widget.gradient),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${widget.score}/${widget.total}',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: widget.gradient[0],
                  ),
                ),
                Text(
                  'إجاباتك الصحيحة',
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}