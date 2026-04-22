import 'package:athr/core/utils/app_styles.dart';
import 'package:athr/features/reminder/presentation/views/widgets/icon_item.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class IconSelcetionSection extends StatefulWidget {
  const IconSelcetionSection({super.key, required this.onIconSelected});
    final Function(int) onIconSelected;

  @override
  State<IconSelcetionSection> createState() => _IconSelcetionSectionState();
}

class _IconSelcetionSectionState extends State<IconSelcetionSection> {
   int? currentIndex ;
  final List<IconItem> iconItems = [
    IconItem(icon: Icons.wb_sunny_outlined),
    IconItem(icon: Icons.nightlight_round),
    IconItem(icon: Icons.access_time),
    IconItem(icon: Icons.favorite_border),
    IconItem(icon: Icons.notifications_none),
    IconItem(icon: Icons.menu_book_outlined),
    IconItem(icon: Icons.local_cafe_outlined),
    IconItem(icon: Icons.cloud_outlined),
    IconItem(icon: Icons.dark_mode_outlined),
    IconItem(icon: Icons.star),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختار الأيقونة',
          style: AppStyles.styleMedium16(context),
        ),
        const Gap(20),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 1.4,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: iconItems.length,
           itemBuilder: (context, index) {
             return GestureDetector(
              onTap: () {
                setState(() {
                  currentIndex=index;
                });
                  widget.onIconSelected(iconItems[index].icon.codePoint);
              },
              child: IconItem(
                isSelected: currentIndex == index,
                icon: iconItems[index].icon));
           },)
      ],
    );
  }
}
