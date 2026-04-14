import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PrayerItemShimmer extends StatelessWidget {
  const PrayerItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFECECEC),
      highlightColor: const Color(0xFFF7F7F7),
      child: SizedBox(
        height: 100,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          separatorBuilder: (_, index) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            return Container(
              width: 85,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(height: 10, width: 45, color: Colors.white),
                  Container(height: 10, width: 35, color: Colors.white),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}