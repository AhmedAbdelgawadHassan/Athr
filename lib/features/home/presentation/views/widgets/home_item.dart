import 'package:athr/core/utils/app_styles.dart';
import 'package:athr/features/home/data/models/home_item_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeItem extends StatelessWidget {
  const HomeItem({super.key, required this.homeItemModel});
  final HomeItemModel homeItemModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: homeItemModel.onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: homeItemModel.color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(homeItemModel.icon, color: Colors.white, size: 30),
            ),
            const Gap(12),
             Text(homeItemModel.title, style: AppStyles.styleMedium18(context)),
                  Gap(5),
                  Text(
                    homeItemModel.subtitle,
                    style: AppStyles.styleRegular12(
                      context,
                    ).copyWith(color: Color(0xff6B6B6B)),
                  ),
          ],
        ),
      ),
    );
  }
}
