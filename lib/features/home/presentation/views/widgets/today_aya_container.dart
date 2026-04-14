import 'package:athr/core/functions/circle_drawer.dart';
import 'package:athr/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TodayAyaContainer extends StatelessWidget {
  const TodayAyaContainer({super.key});

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
          child: Column(
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
                '﴿ وَقُل رَّبِّ زِدۡنِی عِلۡمࣰا ﴾',
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
                'سورة طه - آية 114',
                style: AppStyles.styleRegular14(
                  context,
                ).copyWith(color: Color(0xff6B6B6B)),
              ),
              Gap(30)
            ],
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
