// ignore_for_file: deprecated_member_use

import 'package:athr/core/utils/app_styles.dart';
import 'package:athr/features/home/data/models/home_item_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class HomeItem extends StatelessWidget {
  const HomeItem({super.key, required this.homeItemModel});
  final HomeItemModel homeItemModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => homeItemModel.buildNavigationScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              homeItemModel.color.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: Colors.black26,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP ROW (ICON + DECORATION DOT)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        homeItemModel.color,
                        homeItemModel.color.withOpacity(0.6),
                      ],
                    ),
                  ),
                  child: _HomeItemIcon(icon: homeItemModel.icon),
                ),

                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: homeItemModel.color.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),

            const Gap(16),

            // TITLE
            Text(
              homeItemModel.title,
              style: AppStyles.styleMedium18(context).copyWith(
                color: const Color(0xff1A1A1A),
                height: 1.2,
              ),
            ),

            const Gap(6),

            // SUBTITLE
            Text(
              homeItemModel.subtitle,
              style: AppStyles.styleRegular12(context).copyWith(
                color: const Color(0xff6F6F6F),
                height: 1.5,
              ),
            ),

            const Gap(14),

            // BOTTOM INDICATOR
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 35,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: homeItemModel.color.withOpacity(0.3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeItemIcon extends StatelessWidget {
  const _HomeItemIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final dir = Directionality.maybeOf(context) ?? TextDirection.rtl;

    if (icon.fontPackage == 'font_awesome_flutter') {
      return FaIcon(
        FaIconData(icon),
        color: Colors.white,
        size: 22,
        textDirection: dir,
      );
    }

    return Icon(
      icon,
      color: Colors.white,
      size: 22,
    );
  }
}