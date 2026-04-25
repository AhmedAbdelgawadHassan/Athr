// ignore_for_file: deprecated_member_use

import 'package:athr/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class AdviceContainer extends StatelessWidget {
  const AdviceContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            const Color(0xffEDDEBA).withOpacity(0.9),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: const Color(0xffD4AF37).withOpacity(0.35),
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ICON
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xffD4AF37),
                  const Color(0xffD4AF37).withOpacity(0.6),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xffD4AF37).withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child:  Icon(
              FontAwesomeIcons.lightbulb.data,
              color: Colors.white,
              size: 18,
            ),
          ),

          const Gap(12),

          // TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'نصيحة اليوم ✨',
                  style: AppStyles.styleSemiBold18(context).copyWith(
                    color: const Color(0xff2C2C2C),
                  ),
                ),
                const Gap(8),
                Text(
                  'المداومة على الأذكار اليومية تجلب السكينة والطمأنينة للقلب. احرص على تفعيل التذكيرات لتبقى على اتصال دائم بالله.',
                  style: AppStyles.styleRegular14(context).copyWith(
                    color: const Color(0xff6B6B6B),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}