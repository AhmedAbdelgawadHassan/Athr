// ignore_for_file: deprecated_member_use

import 'package:athr/core/utils/app_colors.dart';
import 'package:athr/core/utils/app_styles.dart';
import 'package:athr/features/quranKarim/data/models/sura_model.dart';
import 'package:athr/features/quranKarim/presentation/manager/sura_cubit.dart';
import 'package:athr/features/quranKarim/presentation/manager/sura_state.dart';
import 'package:athr/features/quranKarim/presentation/views/painters/moshaf_pinter.dart';
import 'package:athr/features/quranKarim/presentation/views/widgets/aya_end_marker.dart';
import 'package:athr/features/quranKarim/presentation/views/widgets/error_widget.dart';
import 'package:athr/features/quranKarim/presentation/views/widgets/page_footer.dart';
import 'package:athr/features/quranKarim/presentation/views/widgets/page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class SurahDetailsView extends StatelessWidget {
  const SurahDetailsView({super.key, required this.surahModel});

  final SuraModel surahModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SurahCubit()..loadSurah(surahModel.number),
      child: _SurahDetailsBody(surahModel: surahModel),
    );
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _SurahDetailsBody extends StatelessWidget {
  const _SurahDetailsBody({required this.surahModel});
  final SuraModel surahModel;

  // سورة الفاتحة (1) بسملتها جزء من نصها، سورة التوبة (9) لا بسملة
  bool get _hasBismillah => surahModel.number != 9;
  bool get _isMeccan => surahModel.revelationType == 'Meccan';
  Color get _accent =>
      _isMeccan ? AppColors.primaryColor : AppColors.secondaryColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5EDD6),
      body: CustomScrollView(
        slivers: [
          // ── App Bar ───────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.primaryColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              surahModel.name,
              style: const TextStyle(
                fontFamily: 'ScheherazadeNew',
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12,left: 12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.6)),
                  ),
                  child: Text(
                    _isMeccan ? 'مكية' : 'مدنية',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),

          // ── Content ───────────────────────────────────────────────────────
          BlocBuilder<SurahCubit, SurahState>(
            builder: (context, state) {
              if (state is SurahLoading) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: _accent),
                        const Gap(16),
                        Text(
                          'جارٍ تحميل السورة...',
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is SurahError) {
                return SliverFillRemaining(
                  child: ErrprWidgets(
                    message: state.message,
                    accent: _accent,
                    onRetry: () =>
                        context.read<SurahCubit>().loadSurah(surahModel.number),
                  ),
                );
              }

              if (state is SurahLoaded) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: _MushafPage(
                      ayahs: state.ayahs,
                      surahModel: surahModel,
                      hasBismillah: _hasBismillah,
                      accent: _accent,
                    ),
                  ),
                );
              }

              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),

          const SliverToBoxAdapter(child: Gap(40)),
        ],
      ),
    );
  }
}

// ─── صفحة المصحف الكاملة ─────────────────────────────────────────────────────

class _MushafPage extends StatelessWidget {
  const _MushafPage({
    required this.ayahs,
    required this.surahModel,
    required this.hasBismillah,
    required this.accent,
  });

  final List<AyahQuranModel> ayahs;
  final SuraModel surahModel;
  final bool hasBismillah;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MushafBorderPainter(accentColor: accent),
      child: Container(
        // هامش داخلي يترك مسافة للإطار المرسوم
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xffFEF9EE),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            // ── رأس الصفحة (اسم السورة وعدد الآيات) ─────────────────────
            PageHeader(surahModel: surahModel, accent: accent),

            // ── البسملة (صورة) ────────────────────────────────────────────
            if (hasBismillah)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Image.asset(
                  'assets/images/Basmala.png',
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              ),

            // ── النص القرآني المتواصل ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 4, 22, 16),
              child: _buildQuranText(context),
            ),

            // ── ذيل الصفحة ────────────────────────────────────────────────
            PageFooter(surahModel: surahModel, accent: accent),
          ],
        ),
      ),
    );
  }

  Widget _buildQuranText(BuildContext context) {
    final spans = <InlineSpan>[];

    for (final ayah in ayahs) {
      spans.add(
        TextSpan(
            text: '${ayah.text} ',
            style: AppStyles.styleMedium24(context).copyWith(
              fontFamily: 'ScheherazadeNew',
              fontSize: 22,
              height: 2.4,
               
              color: Colors.black,
              letterSpacing: 0,
            )),
      );

      // رقم الآية بالشكل الدائري
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: AyahEndMarker(number: ayah.numberInSurah, color: accent),
        ),
      );

      spans.add(const TextSpan(text: '  '));
    }

    return RichText(
      textAlign: TextAlign.justify,
      textDirection: TextDirection.rtl,
      text: TextSpan(children: spans),
    );
  }
}

enum CornerType { topLeft, topRight, bottomLeft, bottomRight }
