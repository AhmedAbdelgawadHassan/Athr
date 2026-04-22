// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class OrnamentLine extends StatelessWidget {
  final Color color;
  const OrnamentLine({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.0),
              color,
              color.withOpacity(0.0),
            ],
          ),
        ),
      ),
    );
  }
}