// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

/// ─── Islamic Color Palette ───────────────────────────────────────────────────
///
///  Default  → Antique Gold  (#8B6914 badge / #FDFAF3 bg / #C9A96E border)
///  Correct  → Emerald Green (#1B6B3A badge / #F0FAF4 bg / #1B6B3A border)
///  Wrong    → Terracotta    (#C2622A badge / #FDF3EC bg / #C2622A border)
///  Faded    → Parchment     (#9E8E72 badge / #F7F5F0 bg / #C9B99A border)
///
/// ─────────────────────────────────────────────────────────────────────────────

class QuizOptionItem extends StatelessWidget {
  final String text;
  final int index;
  final bool isSelected;
  final bool isCorrect;
  final bool isRevealed;
  final VoidCallback? onTap;

  const QuizOptionItem({
    super.key,
    required this.text,
    required this.index,
    required this.isSelected,
    required this.isCorrect,
    required this.isRevealed,
    this.onTap,
  });

  // ── Antique gold (default) ──────────────────────────────────────────────────
  static const _goldBadge   = Color(0xFF8B6914);
  static const _goldBorder  = Color(0xFFC9A96E);
  static const _goldBg      = Color(0xFFFDFAF3);
  static const _goldText    = Color(0xFF3B2A0E);

  // ── Emerald green (correct) ─────────────────────────────────────────────────
  static const _greenBadge  = Color(0xFF1B6B3A);
  static const _greenBorder = Color(0xFF1B6B3A);
  static const _greenBg     = Color(0xFFF0FAF4);
  static const _greenText   = Color(0xFF0D3D21);
  static const _greenGlow   = Color(0xFF1B6B3A);

  // ── Terracotta (wrong selected) ─────────────────────────────────────────────
  static const _terraBadge  = Color(0xFFC2622A);
  static const _terraBorder = Color(0xFFC2622A);
  static const _terraBg     = Color(0xFFFDF3EC);
  static const _terraText   = Color(0xFF6B2C0E);
  static const _terraGlow   = Color(0xFFC2622A);

  // ── Parchment (faded / not selected after reveal) ───────────────────────────
  static const _fadedBadge  = Color(0xFF9E8E72);
  static const _fadedBorder = Color(0xFFC9B99A);
  static const _fadedBg     = Color(0xFFF7F5F0);
  static const _fadedText   = Color(0xFF7A6D5C);

  @override
  Widget build(BuildContext context) {
    final optionLabels = ['أ', 'ب', 'ج', 'د'];

    // ── Resolve colors based on state ──────────────────────────────────────────
    final Color borderColor;
    final Color bgColor;
    final Color badgeColor;
    final Color textColor;
    final Color shadowColor;
    Widget? trailingIcon;

    if (isRevealed) {
      if (isCorrect) {
        borderColor = _greenBorder;
        bgColor     = _greenBg;
        badgeColor  = _greenBadge;
        textColor   = _greenText;
        shadowColor = _greenGlow.withOpacity(0.18);
        trailingIcon = const _IslamicCheckIcon();
      } else if (isSelected) {
        borderColor = _terraBorder;
        bgColor     = _terraBg;
        badgeColor  = _terraBadge;
        textColor   = _terraText;
        shadowColor = _terraGlow.withOpacity(0.14);
        trailingIcon = const _IslamicCrossIcon();
      } else {
        borderColor = _fadedBorder;
        bgColor     = _fadedBg;
        badgeColor  = _fadedBadge;
        textColor   = _fadedText;
        shadowColor = Colors.transparent;
        trailingIcon = null;
      }
    } else {
      borderColor = _goldBorder;
      bgColor     = _goldBg;
      badgeColor  = _goldBadge;
      textColor   = _goldText;
      shadowColor = _goldBadge.withOpacity(0.10);
      trailingIcon = null;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isRevealed ? null : onTap,
          borderRadius: BorderRadius.circular(14),
          splashColor: _goldBadge.withOpacity(0.08),
          highlightColor: _goldBadge.withOpacity(0.04),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // ── Badge ───────────────────────────────────────────────────
                AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    optionLabels[index],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // ── Option text ─────────────────────────────────────────────
                Expanded(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 350),
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Cairo',
                    ),
                    child: Text(text, textDirection: TextDirection.rtl),
                  ),
                ),

                // ── Trailing icon ───────────────────────────────────────────
                if (trailingIcon != null) ...[
                  const SizedBox(width: 8),
                  trailingIcon,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Custom Islamic-style check icon (star/crescent inspired) ──────────────────

class _IslamicCheckIcon extends StatelessWidget {
  const _IslamicCheckIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: const Color(0xFF1B6B3A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
    );
  }
}

class _IslamicCrossIcon extends StatelessWidget {
  const _IslamicCrossIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: const Color(0xFFC2622A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.close_rounded, color: Colors.white, size: 16),
    );
  }
}