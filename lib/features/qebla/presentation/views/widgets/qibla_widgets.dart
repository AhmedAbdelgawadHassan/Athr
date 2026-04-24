// ignore_for_file: deprecated_member_use
import 'package:athr/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';

// ── بطاقة الدرجة ──────────────────────────────────────────────
class DegreeCard extends StatelessWidget {
  final double degree;
  final bool isAligned;
  final Animation<double> pulseAnimation;

  const DegreeCard({
    super.key,
    required this.degree,
    required this.isAligned,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (_, __) => Transform.scale(
        scale: isAligned ? pulseAnimation.value : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: LinearGradient(
              colors: isAligned
                  ? [AppColors.tealLight, const Color(0xFFE0F2F1)]
                  : [const Color(0xFFFFF8E1), const Color(0xFFFFF3CD)],
            ),
            border: Border.all(
              color: isAligned ? AppColors.teal : AppColors.gold,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: (isAligned ? AppColors.teal : AppColors.gold).withOpacity(0.2),
                blurRadius: 16,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isAligned ? Icons.check_circle_rounded : Icons.explore_rounded,
                color: isAligned ? AppColors.teal : AppColors.gold,
                size: 18,
              ),
              const SizedBox(width: 10),
              Text(
                '${degree.toStringAsFixed(1)}°',
                style: TextStyle(
                  color: isAligned ? AppColors.teal : AppColors.gold,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(width: 6),
              Text('شمالاً', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── بانر الحالة ───────────────────────────────────────────────
class StatusBanner extends StatelessWidget {
  final bool isAligned;
  final double offset;

  const StatusBanner({super.key, required this.isAligned, required this.offset});

  @override
  Widget build(BuildContext context) {
    final color = isAligned ? AppColors.teal : AppColors.gold;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isAligned ? AppColors.tealLight.withOpacity(0.4) : AppColors.bgCard,
        border: Border.all(color: color.withOpacity(isAligned ? 0.5 : 0.3), width: 1),
        boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.12),
            ),
            child: Icon(
              isAligned ? Icons.mosque_rounded : Icons.navigation_rounded,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAligned ? 'أنت في اتجاه القبلة' : 'حرّك الهاتف نحو القبلة',
                  style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  isAligned
                      ? 'استقبل القبلة وابدأ صلاتك'
                      : 'الانحراف: ${offset.toStringAsFixed(1)}° عن الاتجاه الصحيح',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── صف المعلومات ──────────────────────────────────────────────
class InfoRow extends StatelessWidget {
  final QiblahDirection qiblah;
  final bool isAligned;

  const InfoRow({super.key, required this.qiblah, required this.isAligned});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _InfoCard(
            icon: Icons.explore_outlined,
            label: 'الانحراف',
            value: '${qiblah.offset.abs().toStringAsFixed(1)}°',
            accent: isAligned ? AppColors.teal : AppColors.gold,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _InfoCard(
            icon: Icons.my_location_rounded,
            label: 'اتجاه الهاتف',
            value: '${qiblah.direction.toStringAsFixed(0)}°',
            accent: AppColors.gold,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _InfoCard(
            icon: Icons.star_rounded,
            label: 'الدقة',
            value: isAligned ? 'ممتازة' : 'غير دقيق',
            accent: isAligned ? AppColors.teal : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withOpacity(0.25), width: 1),
        boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Icon(icon, color: accent, size: 20),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 10), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
