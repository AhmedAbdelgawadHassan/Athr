import 'package:athr/features/azkar/presentation/view/widgets/onament_line.dart';
import 'package:athr/features/azkar/presentation/view/widgets/azkar_list_widget.dart';
import 'package:flutter/material.dart' hide CardTheme;

class CardHeader extends StatelessWidget {
  final int index;
  final CardTheme theme;

  const CardHeader({super.key, required this.index, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Row(
        children: [
          // زخرفة يمين
          OrnamentLine(color: theme.border),

          const SizedBox(width: 10),

          // نجمة + رقم
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_rounded, size: 13, color: theme.accent),
              const SizedBox(width: 5),
              Text(
                'دعاء ${index + 1}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: theme.number,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 5),
              Icon(Icons.star_rounded, size: 13, color: theme.accent),
            ],
          ),

          const SizedBox(width: 10),

          // زخرفة يسار
          OrnamentLine(color: theme.border),
        ],
      ),
    );
  }
}