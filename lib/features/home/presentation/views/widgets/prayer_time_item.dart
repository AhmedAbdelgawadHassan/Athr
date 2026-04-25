import 'package:athr/core/utils/app_styles.dart';
import 'package:athr/features/home/data/models/prayer_time_item_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PrayerTimeItem extends StatelessWidget {
  const PrayerTimeItem({super.key, required this.prayerTimeItemModel,});
  final PrayerTimeItemModel prayerTimeItemModel;

  @override
  Widget build(BuildContext context) {
    String formatTo12Hour(String time) {
  final parts = time.split(':');
  int hour = int.parse(parts[0]);
  final minute = parts[1];

  String period = "AM";

  if (hour >= 12) {
    period = "PM";
    if (hour > 12) hour -= 12;
  }

  if (hour == 0) {
    hour = 12;
  }

  return "$hour:$minute $period";
}
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: prayerTimeItemModel.color
          ),
          child: Image(image: AssetImage(prayerTimeItemModel.icon),width: 20,height: 20,),
        ),
        const Gap(7),
        Text(prayerTimeItemModel.name,style: AppStyles.styleRegular12(context).copyWith(color: Color(0xff6B6B6B)),),
        const Gap(3),
         Text(formatTo12Hour(prayerTimeItemModel.time),style: AppStyles.styleMedium12(context),),
      ],
    );
  }
} 