// ignore_for_file: deprecated_member_use

import 'package:athr/features/azkar/presentation/view/widgets/doaa_card.dart';
import 'package:flutter/material.dart';

class AzkarListWidget extends StatefulWidget {
  final List<String> azkar;

  const AzkarListWidget({
    super.key,
    required this.azkar,
  });

  @override
  State<AzkarListWidget> createState() => AzkarListWidgetState();
}

class AzkarListWidgetState extends State<AzkarListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8,),
      itemCount: widget.azkar.length,
      itemBuilder: (context, index) {
        return DuaaCard(
          zikr: widget.azkar[index],
          index: index,
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────
//  Palette per card  (روحاني وهادي)
// ─────────────────────────────────────────────────
const List<CardTheme> kThemes = [
CardTheme(
    bg: Color(0xFFF0F7F4),
    border: Color(0xFFB2D8CA),
    accent: Color(0xFF2D7A5F),
    icon: Color(0xFF2D7A5F),
    number: Color(0xFF1A5E47),
  ),
  CardTheme(
    bg: Color(0xFFF5F0E8),
    border: Color(0xFFD4BF98),
    accent: Color(0xFF7A5C2D),
    icon: Color(0xFF7A5C2D),
    number: Color(0xFF5C4020),
  ),
  CardTheme(
    bg: Color(0xFFEEF2F7),
    border: Color(0xFFB2C4D8),
    accent: Color(0xFF2D537A),
    icon: Color(0xFF2D537A),
    number: Color(0xFF1A3D5E),
  ),
  CardTheme(
    bg: Color(0xFFF5EEF5),
    border: Color(0xFFCFB2CF),
    accent: Color(0xFF6B3E7A),
    icon: Color(0xFF6B3E7A),
    number: Color(0xFF4E2A5A),
  ),
];

class CardTheme {
  final Color bg, border, accent, icon, number;
  const CardTheme({
    required this.bg,
    required this.border,
    required this.accent,
    required this.icon,
    required this.number,
  });
}




