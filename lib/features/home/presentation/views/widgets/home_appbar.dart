import 'package:athr/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeAppbar extends StatelessWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تطبيق أثر',
              style: AppStyles.styleMedium30(
                context,
              ).copyWith(color: Colors.white),
            ),
            const Gap(5),
            Text(
              'سلام عليكم ورحمة الله وبركاته',
              style: AppStyles.styleRegular14(
                context,
              ).copyWith(color: Colors.white),
            ),
          ],
        ),
        Spacer(),
        InkWell(
          onTap: (){},
          child: Icon(Icons.dark_mode_outlined,color: Colors.white,)),
        Gap(25),
        InkWell(
          onTap: (){},
          child: Icon(Icons.settings_outlined,color: Colors.white,)),
      ],
    );
  }
}
