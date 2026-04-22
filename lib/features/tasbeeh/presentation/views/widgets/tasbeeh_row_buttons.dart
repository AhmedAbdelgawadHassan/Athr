import 'package:athr/features/tasbeeh/presentation/views/widgets/info_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TasbeehRowButtons extends StatelessWidget {
  const TasbeehRowButtons({
    super.key,
    required this.resetOnTap,
    required this.total,
    required this.rounds,
  });

  final VoidCallback resetOnTap;
  final int total;
  final int rounds;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// RESET BUTTON
        Expanded(
          child: ElevatedButton.icon(
            onPressed: resetOnTap,
            icon: const Icon(Icons.refresh, size: 20),
            label: const Text("إعادة تعيين"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              elevation: 4,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        Gap(10),

        /// TOTAL CARD
        Expanded(
          child: InfoCard(
            title: "الإجمالي",
            value: total.toString(),
            icon: Icons.bar_chart_rounded,
          ),
        ),
        Gap(10),

        /// ROUNDS CARD
        Expanded(
          child: InfoCard(
            title: "الجولات",
            value: rounds.toString(),
            icon: Icons.repeat_rounded,
          ),
        ),
      ],
    );
  }
}

/// reusable widget عشان الشكل يبقى consistent
