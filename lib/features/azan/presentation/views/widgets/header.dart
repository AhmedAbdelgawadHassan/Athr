// ignore_for_file: deprecated_member_use

import 'package:athr/features/azan/presentation/manager/cubits/adhan_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Header extends StatelessWidget {
  final AdhanLoaded state;
  const Header({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE، d MMMM yyyy', 'ar').format(now);
    final nextPrayer = state.prayers[state.nextPrayerIndex];
    final h = state.timeToNextPrayer.inHours;
    final m = state.timeToNextPrayer.inMinutes.remainder(60);
    final timeLeft = h > 0 ? 'بعد $h ساعة و$m دقيقة' : 'بعد $m دقيقة';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B6B45), Color(0xFF0D4A2F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B6B45).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dateStr,
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time_rounded,
                  color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'القادمة: ${nextPrayer.name}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(right: 28),
            child: Text(
              timeLeft,
              style: const TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
