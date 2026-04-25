// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../../../data/models/prayer_model.dart';

class PrayerCard extends StatelessWidget {
  final PrayerModel prayer;
  final bool isNext;           // هل هي الصلاة الجاية؟
  final VoidCallback onToggle; // لما المستخدم يضغط الـ toggle

  const PrayerCard({
    super.key,
    required this.prayer,
    required this.isNext,
    required this.onToggle,
    this.progress = 0,
  });

  // progress بيتبعت بس للصلاة الجاية
  final double progress;

  @override
  Widget build(BuildContext context) {
    return isNext
        ? _NextPrayerCard(prayer: prayer, progress: progress, onToggle: onToggle)
        : _NormalPrayerCard(prayer: prayer, onToggle: onToggle);
  }
}

// ── كارد الصلاة العادية ───────────────────────────────────────
class _NormalPrayerCard extends StatelessWidget {
  final PrayerModel prayer;
  final VoidCallback onToggle;

  const _NormalPrayerCard({required this.prayer, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    String formatTo12Hour(String time) {
  final parts = time.split(':');
  int hour = int.parse(parts[0]);
  final minute = parts[1];

  String period = "AM";

  if (hour >= 12) {
    period = "PM";
    if (hour > 12) hour -= 12;
  }

  if (hour == 0) {
    hour = 12;
  }

  return "$hour:$minute $period";
}
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── الوقت والتفعيل (يسار) ──
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formatTo12Hour(prayer.time),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 6),
              _ToggleRow(isEnabled: prayer.isEnabled, onToggle: onToggle),
            ],
          ),

          const Spacer(),

          // ── اسم الصلاة والأيقونة (يمين) ──
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                prayer.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 8),
              _PrayerIcon(imagePath: prayer.imagePath),
            ],
          ),
        ],
      ),
    );
  }
}

// ── كارد الصلاة الجاية (خضراء مع progress bar) ───────────────
class _NextPrayerCard extends StatelessWidget {
  final PrayerModel prayer;
  final double progress;
  final VoidCallback onToggle;

  const _NextPrayerCard({
    required this.prayer,
    required this.progress,
    required this.onToggle,
  });

  static const _green     = Color(0xFF1B6B45);
  static const _greenDark = Color(0xFF145236);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_green, _greenDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.4), width: 1),
        boxShadow: [
          BoxShadow(
            color: _green.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // ── الوقت والتفعيل ──
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prayer.time,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _ToggleRow(
                    isEnabled: prayer.isEnabled,
                    onToggle: onToggle,
                    textColor: Colors.white70,
                  ),
                ],
              ),

              const Spacer(),

              // ── اسم الصلاة والأيقونة ──
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    prayer.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _PrayerIcon(imagePath: prayer.imagePath, size: 44),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Progress Bar ──
          _ProgressBar(progress: progress),
        ],
      ),
    );
  }
}

// ── Progress Bar ──────────────────────────────────────────────
class _ProgressBar extends StatelessWidget {
  final double progress;
  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
            const Text(
              'الوقت المتبقي',
              style: TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
          ),
        ),
      ],
    );
  }
}

// ── Toggle Row (الجرس + السويتش) ─────────────────────────────
class _ToggleRow extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onToggle;
  final Color textColor;

  const _ToggleRow({
    required this.isEnabled,
    required this.onToggle,
    this.textColor = const Color(0xFF6B7280),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isEnabled ? Icons.notifications_active_rounded : Icons.notifications_off_rounded,
          size: 16,
          color: textColor,
        ),
        const SizedBox(width: 6),
        Transform.scale(
          scale: 0.75,
          alignment: Alignment.centerLeft,
          child: Switch(
            value: isEnabled,
            onChanged: (_) => onToggle(),
            activeColor: const Color(0xFF1B6B45),
            activeTrackColor: const Color(0xFF1B6B45).withOpacity(0.3),
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.withOpacity(0.3),
          ),
        ),
        Text(
          isEnabled ? 'مفعّل' : 'مقفل',
          style: TextStyle(fontSize: 11, color: textColor),
        ),
      ],
    );
  }
}

// ── أيقونة الصلاة ─────────────────────────────────────────────
class _PrayerIcon extends StatelessWidget {
  final String imagePath;
  final double size;
  const _PrayerIcon({required this.imagePath, this.size = 38});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(
            Icons.mosque_rounded,
            size: size * 0.55,
            color: const Color(0xFF1B6B45),
          ),
        ),
      ),
    );
  }
}
