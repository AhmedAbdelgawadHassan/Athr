import 'package:athr/core/utils/app_colors.dart';
import 'package:athr/core/utils/app_styles.dart';
import 'package:athr/features/quranKarim/data/models/sura_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SuraItem extends StatelessWidget {
  const SuraItem({super.key, required this.surahModel});

  final SuraModel surahModel;

  @override
  Widget build(BuildContext context) {
    final isMeccan = surahModel.revelationType == 'Meccan';
    final Color accent = isMeccan
        ? AppColors.primaryColor
        : AppColors.secondaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.white, accent.withValues(alpha: 0.09)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: accent.withValues(alpha: 0.12),
                  ),
                  child: Text(
                    isMeccan ? 'مكية' : 'مدنية',
                    style: AppStyles.styleMedium12(
                      context,
                    ).copyWith(color: accent),
                  ),
                ),
                Gap(14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            surahModel.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.styleSemiBold18(context),
                          ),
                          Text(
                            surahModel.englishName,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.styleRegular14(
                              context,
                            ).copyWith(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      Gap(12),
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 16,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'آية ${surahModel.numberOfAyahs}',
                            style: AppStyles.styleRegular14(
                              context,
                            ).copyWith(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Gap(15),

                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        accent.withValues(alpha: 0.2),
                        accent.withValues(alpha: 0.05),
                      ],
                    ),
                    border: Border.all(color: accent.withValues(alpha: 0.6)),
                  ),
                  child: Center(
                    child: Text(
                      surahModel.number.toString(),
                      style: AppStyles.styleSemiBold16(
                        context,
                      ).copyWith(color: accent),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
