// ignore_for_file: deprecated_member_use

import 'package:athr/features/quranKarim/data/models/sura_model.dart';
import 'package:flutter/widgets.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({super.key, required this.surahModel, required this.accent});
  final SuraModel surahModel;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: accent.withOpacity(0.3), width: 1),
          top: BorderSide(color: accent.withOpacity(0.3), width: 1),
        ),
        color: accent.withOpacity(0.05),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // عدد الآيات
          Text(
            '${surahModel.numberOfAyahs} آية',
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 13,
              color: accent.withOpacity(0.8),
            ),
          ),

          // اسم السورة في المنتصف
          Text(
            'سُورَةُ ${surahModel.name}',
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 17,
              color: accent,
              fontWeight: FontWeight.bold,
            ),
          ),

          // رقم السورة
          Text(
            'سورة ${surahModel.number}',
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 13,
              color: accent.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
