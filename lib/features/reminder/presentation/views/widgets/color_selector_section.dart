import 'package:athr/core/utils/app_styles.dart';
import 'package:athr/features/reminder/presentation/views/widgets/color_item.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ColorSelectorSection extends StatefulWidget {
  const ColorSelectorSection({
    super.key,
    required this.onColorSelected,
  });
  final ValueChanged<Color> onColorSelected;

  @override
  State<ColorSelectorSection> createState() => _ColorSelectorSectionState();
}

class _ColorSelectorSectionState extends State<ColorSelectorSection> {
  int? currentIndex;
  final List<ColorItem> colorItems = [
    ColorItem(color: Colors.red),
    ColorItem(color: Colors.green),
    ColorItem(color: Colors.blue),
    ColorItem(color: Colors.yellow),
    ColorItem(color: Colors.orange),
    ColorItem(color: Colors.purple),
    ColorItem(color: Colors.pink),
    ColorItem(color: Colors.brown),
    ColorItem(color: Colors.black),
    ColorItem(color: Colors.cyan),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('اختار لون التذكير', style: AppStyles.styleMedium16(context)),
        const Gap(20),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: colorItems.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  setState(() {
                    currentIndex = index;
                  });
                  widget.onColorSelected(colorItems[index].color);
                },
                child: ColorItem(
                  color: colorItems[index].color,
                  isSelected: currentIndex == index,
                ));
          },
        )
      ],
    );
  }
}
