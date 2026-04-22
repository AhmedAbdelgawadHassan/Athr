import 'package:flutter/material.dart';

class TasbeehOptions extends StatelessWidget {
  const TasbeehOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: const [
        OptionItem(title: "سبحان الله"),
        OptionItem(title: "الحمد لله"),
        OptionItem(title: "الله أكبر"),
        OptionItem(title: "لا إله إلا الله"),
      ],
    );
  }
}

class OptionItem extends StatelessWidget {
  final String title;

  const OptionItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(title),
    );
  }
}