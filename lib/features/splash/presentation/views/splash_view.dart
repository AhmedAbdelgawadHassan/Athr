// ignore_for_file: deprecated_member_use

import 'package:athr/constants.dart';
import 'package:athr/core/functions/circle_drawer.dart';
import 'package:athr/core/services/shared_prefrence.dart';
import 'package:athr/core/utils/app_assets.dart';
import 'package:athr/core/utils/app_colors.dart';
import 'package:athr/core/utils/app_styles.dart';
import 'package:athr/features/home/presentation/views/home_view.dart';
import 'package:athr/features/splash/presentation/views/onboarding_view.dart';
import 'package:athr/features/splash/presentation/views/widgets/custom_linear_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _fade;
  late Animation<double> _scale;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scale = Tween<double>(
      begin: 0.8,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 4));
    if (mounted) {
      Prefs.getBool(kIsOnboardingSeen)
          ? Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeView()),
            )
          : Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => OnboardingView()),
            );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 40,
              left: 25,
              child: drawCircle(
                radius: 60,
                borderColor: AppColors.secondaryColor.withOpacity(0.3),
                backgroundColor: AppColors.primaryColor,
              ),
            ),
            Positioned(
              bottom: 40,
              right: 25,
              child: drawCircle(
                radius: 60,
                borderColor: AppColors.secondaryColor.withOpacity(0.3),
                backgroundColor: AppColors.primaryColor,
              ),
            ),
            Positioned(
              top: 0,
              left: 40,
              right: 40,
              bottom: 0,
              child: drawCircle(
                radius: 60,
                borderColor: AppColors.secondaryColor.withOpacity(0.5),
                backgroundColor: AppColors.primaryColor,
              ),
            ),

            Center(
              child: FadeTransition(
                opacity: _fade,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(flex: 2),
                    // Logo
                    ScaleTransition(
                      scale: _scale,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          AppAssets.appLogo,
                          width: 110,
                          height: 110,
                        ),
                      ),
                    ),

                    const Gap(16),
                    // Text
                    SlideTransition(
                      position: _slide,
                      child: Column(
                        children: [
                          Text(
                            'أثر Athr',
                            style: AppStyles.styleMedium36(context).copyWith(
                              color: Colors.white,
                              fontFamily: 'amiri',
                            ),
                          ),
                          Gap(5),
                          Text(
                            'أثر... حيث تتحول النوايا إلى أعمال خالدة',
                            style: AppStyles.styleMedium16(context).copyWith(
                              color: Colors.white.withOpacity(0.9),
                              fontFamily: 'amiri',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Customlinearprogressindicator(
                      padding: 100,
                    ), // linear progress indicator
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
