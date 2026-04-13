// ignore_for_file: deprecated_member_use

import 'package:athr/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class HeaderItem extends StatelessWidget {
  const HeaderItem({super.key, required this.icone, required this.color});
  final IconData icone;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          
          ),
          child: Icon( icone,color:  Colors.white, size: 35),
        );
  }
}