// ignore_for_file: deprecated_member_use

import 'package:athr/core/utils/app_colors.dart';
import 'package:athr/core/utils/app_styles.dart';
import 'package:athr/features/quranKarim/data/models/sura_model.dart';
import 'package:athr/features/quranKarim/presentation/views/surah_details_view.dart';
import 'package:athr/features/quranKarim/presentation/views/widgets/custom_textfield.dart';
import 'package:athr/features/quranKarim/presentation/views/widgets/quran_card_item.dart';
import 'package:athr/features/quranKarim/presentation/views/widgets/sura_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class QuranView extends StatefulWidget {
  const QuranView({super.key});

  @override
  State<QuranView> createState() => _QuranViewState();
}

class _QuranViewState extends State<QuranView> {
  String _query = '';

  String _normalizeArabic(String text) {
    final buffer = StringBuffer();
    for (final rune in text.runes) {
      if (rune >= 0x064B && rune <= 0x065F) continue;
      if (rune == 0x0670) continue;
      if (rune >= 0x06D6 && rune <= 0x06ED) continue;
      if (rune >= 0x08F0 && rune <= 0x08FF) continue;
      buffer.writeCharCode(rune);
    }
    return buffer.toString();
  }

  List<SuraModel> _filteredSurahs() {
    final query = _query.trim();
    if (query.isEmpty) return SuraModel.suras;

    final normalizedQuery = _normalizeArabic(query).toLowerCase();
    final numberQuery = int.tryParse(query);

    return SuraModel.suras.where((s) {
      if (numberQuery != null && s.number == numberQuery) return true;
      final normalizedArabicName = _normalizeArabic(s.name).toLowerCase();
      if (normalizedArabicName.contains(normalizedQuery)) return true;
      if (s.englishName.toLowerCase().contains(normalizedQuery)) return true;
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final surahs = _filteredSurahs();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          "القرآن الكريم",
          style: AppStyles.styleMedium24(context).copyWith(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Customtextfield(
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
            const SliverToBoxAdapter(child: Gap(20)),
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  QuranCardItem(
                    title: 'سورة',
                    icon: FontAwesomeIcons.bookOpen.data,
                    value: 114,
                    cardColor: const Color(0xffD2E3DB),
                    valueColor: AppColors.primaryColor,
                    iconColor: AppColors.primaryColor,
                    border: AppColors.primaryColor.withOpacity(0.65),
                  ),
                  QuranCardItem(
                    title: 'آية',
                    icon: FontAwesomeIcons.star.data,
                    value: 6236,
                    cardColor: const Color(0xffD2E3DB),
                    valueColor: AppColors.secondaryColor,
                    iconColor: AppColors.secondaryColor,
                    border: AppColors.secondaryColor.withOpacity(0.65),
                  ),
                  QuranCardItem(
                    title: 'صفحة',
                    icon: FontAwesomeIcons.bookmark.data,
                    value: 604,
                    cardColor: const Color(0xffD2E3DB),
                    valueColor: AppColors.primaryColor,
                    iconColor: AppColors.primaryColor,
                    border: AppColors.primaryColor.withOpacity(0.65),
                  ),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: Gap(20)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: surahs.isEmpty
                    ? Center(
                        child: Text(
                          'لا توجد سورة تطابق البحث',
                          style: AppStyles.styleRegular16(context),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: surahs.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  // ✅ تمرير السورة المختارة
                                  builder: (_) => SurahDetailsView(
                                    surahModel: surahs[index],
                                  ),
                                ),
                              );
                            },
                            child: SuraItem(surahModel: surahs[index]),
                          );
                        },
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          color: Colors.grey.shade400,
                          thickness: 1,
                          indent: 30,
                          endIndent: 30,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}