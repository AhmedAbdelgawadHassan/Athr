// ignore_for_file: deprecated_member_use

import 'package:athr/core/utils/app_styles.dart';
import 'package:athr/features/home/presentation/manager/cubits/aya_cubit/aya_cubit.dart';
import 'package:athr/features/home/presentation/manager/cubits/aya_cubit/aya_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class TodayAyaContainer extends StatelessWidget {
  const TodayAyaContainer({super.key});

  @override
 Widget build(BuildContext context) {
  return BlocBuilder<AyahCubit, dynamic>(
    builder: (context, state) {
      if (state is AyahLoading) {
        return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator(color: Color(0xffD4AF37))));
      }
      if (state is AyahSuccess) {
        return Container(
          margin: const EdgeInsets.symmetric( vertical: 8),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xffFFFBF2), // لون فاتح جداً مريح للعين
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xffD4AF37).withOpacity(0.3), width: 1),
            boxShadow: [
              BoxShadow(
                color: const Color(0xffD4AF37).withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // أيقونة دائرية مع ظل
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xffD4AF37).withOpacity(0.1),
                ),
                child: const Icon(Icons.menu_book_rounded, color: Color(0xff0D7E5E), size: 28),
              ),
              const Gap(12),
              Text(
                'آية اليوم',
                style: AppStyles.styleRegular14(context).copyWith(color: const Color(0xff8B7355)),
              ),
              const Gap(15),
              // الآية بتنسيق مميز
              Text(
                state.ayah.ayah,
                textAlign: TextAlign.center,
                style: AppStyles.styleRegular24(context).copyWith(
                  fontFamily: 'amiri',
                  color: const Color(0xff2D2D2D),
                  height: 1.6, // تباعد أفضل بين السطور
                ),
              ),
              const Gap(15),
              // خط فاصل زخرفي بسيط
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 40, height: 1, color: const Color(0xffD4AF37).withOpacity(0.5)),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.star_rounded, size: 14, color: Color(0xffD4AF37))),
                  Container(width: 40, height: 1, color: const Color(0xffD4AF37).withOpacity(0.5)),
                ],
              ),
              const Gap(15),
              Text(
                "سورة ${state.ayah.surah} | آية ${state.ayah.number}",
                style: AppStyles.styleRegular12(context).copyWith(color: const Color(0xffA69376)),
              ),
            ],
          ),
        );
      }
      return const SizedBox(); // في حال الخطأ
    },
  );
}
}