// ignore_for_file: deprecated_member_use

import 'package:athr/core/utils/app_styles.dart';
import 'package:athr/features/azkar/data/models/azkar_category_model.dart';
import 'package:athr/features/azkar/presentation/view/azkar_detail_view.dart';
import 'package:flutter/material.dart';

class AzkarCard extends StatelessWidget {
  const AzkarCard({
    super.key,
    required this.azkarCategoryModel,
  });

  final AzkarCategoryModel azkarCategoryModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return AzkarDetailView(
              title: azkarCategoryModel.title,
              image: azkarCategoryModel.image,
              azkars: azkarCategoryModel.azkars
              
            );
          },
        ));
      },
      child: Container(
        height: 150,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              /// 🔹 Background Image
              Positioned.fill(
                child: Image.asset(
                  azkarCategoryModel.image,
                  fit: BoxFit.cover,
                ),
              ),

              /// 🔹 Gradient Overlay (important for readability)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.6),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              /// 🔹 Top Row (Arrow + Small Image)
              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                ),
              ),

              /// 🔹 Text Content
              Positioned(
                bottom: 16,
                right: 16,
                left: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      azkarCategoryModel.title,
                      textAlign: TextAlign.right,
                      style: AppStyles.styleMedium20(context).copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      azkarCategoryModel.subtitle,
                      textAlign: TextAlign.right,
                      style: AppStyles.styleMedium12(context).copyWith(
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
