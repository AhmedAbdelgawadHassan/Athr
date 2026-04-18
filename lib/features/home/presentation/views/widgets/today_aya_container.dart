import 'package:athr/core/functions/circle_drawer.dart';
import 'package:athr/core/utils/app_styles.dart';
import 'package:athr/features/home/presentation/manager/cubits/aya_cubit/aya_cubit.dart';
import 'package:athr/features/home/presentation/manager/cubits/aya_cubit/aya_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';


/// aya Displayed according to the Number of the Day in the Year
class TodayAyaContainer extends StatefulWidget {
  const TodayAyaContainer({super.key});

  @override
  State<TodayAyaContainer> createState() => _TodayAyaContainerState();
}

class _TodayAyaContainerState extends State<TodayAyaContainer> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xffEDDEBA),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Color(0xffD4AF37), width: 2.5),
          ),
          child: BlocBuilder<AyahCubit, dynamic>(
            builder: (context, state) {
              if (state is AyahLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is AyahSuccess) {
                return Column(
                  children: [
                    Gap(7),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffD4AF37),
                      ),
                      child: Icon(Icons.star, color: Colors.white, size: 25),
                    ),
                    const Gap(10),
                    Text(
                      'آية اليوم',
                      style: AppStyles.styleRegular12(
                        context,
                      ).copyWith(color: Color(0xff6B6B6B)),
                    ),
                    const Gap(10),
                    Divider(
                      thickness: 1,
                      color: Color(0xffD4AF37),
                      indent: 150,
                      endIndent: 150,
                    ),
                    const Gap(10),
                    Text(
                      state.ayah.ayah,
                      style: AppStyles.styleRegular24(
                        context,
                      ).copyWith(fontFamily: 'amiri'),
                    ),
                    const Gap(10),
                    Divider(
                      thickness: 1,
                      color: Color(0xffD4AF37),
                      indent: 150,
                      endIndent: 150,
                    ),
                    const Gap(10),
                    Text(
                      "سورة ${state.ayah.surah} - آية ${state.ayah.number}",
                      style: AppStyles.styleRegular14(
                        context,
                      ).copyWith(color: Color(0xff6B6B6B)),
                    ),
                    Gap(30),
                  ],
                );
              }
              if (state is AyahError) {
                return const Center(child: Text('حدث خطأ ما'));}
                else{
                  return const Center(child: Text('حدث خطأ ما'));
                }

            },
          ),
        ),

        Positioned(
          top: 5,
          right: 9,
          child: drawCircle(
            radius: 35,
            borderColor: Color(0xffD4AF37).withValues(alpha: 0.1),
            backgroundColor: Colors.transparent,
            borderWidth: 10,
          ),
        ),
        Positioned(
          bottom: 5,
          left: 9,
          child: drawCircle(
            radius: 35,
            borderColor: Color(0xffD4AF37).withValues(alpha: 0.1),
            backgroundColor: Colors.transparent,
            borderWidth: 10,
          ),
        ),
      ],
    );
  }
}
