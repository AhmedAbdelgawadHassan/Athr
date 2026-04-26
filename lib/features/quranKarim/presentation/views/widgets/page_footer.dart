// ignore_for_file: deprecated_member_use

import 'package:athr/features/quranKarim/data/models/sura_model.dart';
import 'package:flutter/widgets.dart';

class PageFooter extends StatelessWidget {
  const PageFooter({super.key, required this.surahModel, required this.accent});
  final SuraModel surahModel;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: accent.withOpacity(0.3), width: 1),
        ),
        color: accent.withOpacity(0.04),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          9,
          (i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Container(
              width: i == 4 ? 7 : 4,
              height: i == 4 ? 7 : 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withOpacity(i == 4 ? 0.55 : 0.25),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
