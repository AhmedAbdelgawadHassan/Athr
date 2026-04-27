// ignore_for_file: deprecated_member_use

import 'package:athr/features/quiz/presentation/view/widgets/score_range.dart';
import 'package:flutter/material.dart';

class QuizResultPage extends StatefulWidget {
  final int score;
  final int total;
  final VoidCallback onRestart;

  const QuizResultPage({
    super.key,
    required this.score,
    required this.total,
    required this.onRestart,
  });

  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage>
    with TickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final AnimationController _fadeController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _scaleAnimation =
        CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut);
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _scaleController.forward();
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  _ResultTier get _tier {
    final pct = (widget.score / widget.total) * 100;
    if (pct == 100) {
      return _ResultTier(
        emoji: '🏆',
        title: 'مبروك! درجة مثالية!',
        message:
            'ما شاء الله! أجبت على جميع الأسئلة بصواب. علمك بالدين رائع ومتميز، فأنت حقاً من الراسخين في العلم.',
        gradient: [const Color(0xFFFFD700), const Color(0xFFFFA500)],
        badgeBg: const Color(0xFFFFF8E1),
      );
    } else if (pct >= 80) {
      return _ResultTier(
        emoji: '⭐',
        title: 'أحسنت! نتيجة ممتازة',
        message:
            'بارك الله فيك! نتيجتك تدل على اجتهادك ومعرفتك الجيدة بتعاليم الإسلام. استمر في طلب العلم.',
        gradient: [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
        badgeBg: const Color(0xFFEDE9FE),
      );
    } else if (pct >= 60) {
      return _ResultTier(
        emoji: '👍',
        title: 'جيد! ستتحسن أكثر',
        message:
            'لديك قاعدة علمية جيدة، لكن هناك مجال للتعلم والتطوير. حاول مراجعة المعلومات التي أخطأت فيها.',
        gradient: [const Color(0xFF3B82F6), const Color(0xFF06B6D4)],
        badgeBg: const Color(0xFFEFF6FF),
      );
    } else if (pct >= 40) {
      return _ResultTier(
        emoji: '📖',
        title: 'لا بأس! واصل التعلم',
        message:
            'المعرفة تُكتسب بالمثابرة والتكرار. خصص وقتاً يومياً لقراءة القرآن الكريم والأحاديث النبوية.',
        gradient: [const Color(0xFFF59E0B), const Color(0xFFEF4444)],
        badgeBg: const Color(0xFFFFFBEB),
      );
    } else {
      return _ResultTier(
        emoji: '🌱',
        title: 'ابدأ رحلة التعلم',
        message:
            'كل عالم كان مبتدئاً يوماً ما. طلب العلم فريضة، وأنت في بداية طريق جميل. داوم على الاختبار اليومي.',
        gradient: [const Color(0xFF10B981), const Color(0xFF059669)],
        badgeBg: const Color(0xFFECFDF5),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tier = _tier;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [tier.gradient[0].withOpacity(0.15), Colors.white, Colors.white],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: tier.badgeBg,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: tier.gradient[0].withOpacity(0.25),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(tier.emoji,
                            style: const TextStyle(fontSize: 64)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    tier.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: tier.gradient[0],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ScoreRing(
                      score: widget.score,
                      total: widget.total,
                      gradient: tier.gradient),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      tier.message,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 15,
                        height: 1.8,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: tier.gradient),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: tier.gradient[0].withOpacity(0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: widget.onRestart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.refresh_rounded, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'إعادة الاختبار',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultTier {
  final String emoji;
  final String title;
  final String message;
  final List<Color> gradient;
  final Color badgeBg;

  const _ResultTier({
    required this.emoji,
    required this.title,
    required this.message,
    required this.gradient,
    required this.badgeBg,
  });
}

