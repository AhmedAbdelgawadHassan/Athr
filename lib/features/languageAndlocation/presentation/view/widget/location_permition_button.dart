import 'package:athr/core/utils/app_colors.dart';
import 'package:athr/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LocationPermitionButton extends StatelessWidget {
  const LocationPermitionButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: onPressed,
                  
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                      ),
                      Gap(10),
                      Text(
                        "السماح بالوصول للموقع",
                        style: AppStyles.styleMedium18(
                          context,
                        ).copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                );
  }
}