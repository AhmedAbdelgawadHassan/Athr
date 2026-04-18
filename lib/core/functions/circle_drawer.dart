import 'package:flutter/material.dart';

Widget drawCircle({
  required double radius,
  required Color borderColor,
  required Color backgroundColor,
  double borderWidth = 1,
}) {
  return Container(
    width: radius * 2,
    height: radius * 2,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: backgroundColor,
      border: Border.all(color: borderColor, width: borderWidth),
    ),
  );
}
