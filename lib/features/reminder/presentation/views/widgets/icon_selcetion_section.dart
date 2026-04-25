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
  int? currentIndex;

  // ✅ بس IconData مش IconItem عشان isSelected تتحكم فيها من بره
  final List<IconData> icons = [
    Icons.wb_sunny_outlined,
    Icons.nightlight_round,
    Icons.access_time,
    Icons.favorite_border,
    Icons.notifications_none,
    Icons.menu_book_outlined,
    Icons.local_cafe_outlined,
    Icons.cloud_outlined,
    Icons.dark_mode_outlined,
    Icons.star,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('اختار الأيقونة', style: AppStyles.styleMedium16(context)),
        const Gap(20),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 1.4,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: icons.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() => currentIndex = index);
                widget.onIconSelected(icons[index].codePoint);
              },
              // ✅ IconItem بتاخد isSelected من currentIndex مباشرة
              child: IconItem(
                icon: icons[index],
                isSelected: currentIndex == index,
              ),
            );
          },
        ),
      ],
    );
  }
}