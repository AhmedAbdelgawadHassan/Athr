import 'package:athr/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

/// aya Displayed according to the Number of the Day in the Year
class AdviceContainer extends StatelessWidget {
  const AdviceContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xffEDDEBA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xffD4AF37), width: 2.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffD4AF37),
                ),
                child: Icon(FontAwesomeIcons.lightbulb.data,
                    color: Colors.white, size: 20),
              ),
              const Gap(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('نصيحة',
                      style: AppStyles.styleSemiBold18(
                        context,
                      )),
                  Gap(12),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Text(
                      'المداومة على الأذكار اليومية تجلب السكينة والطمأنينة للقلب. احرص على تفعيل التذكيرات لتبقى على اتصال دائم بالله.',
                      style: AppStyles.styleRegular14(
                        context,
                      ).copyWith(color: Color(0xff6B6B6B)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
