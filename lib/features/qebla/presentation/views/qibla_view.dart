// ignore_for_file: deprecated_member_use, curly_braces_in_flow_control_structures

import 'dart:math';
import 'package:athr/core/utils/app_colors.dart';
import 'package:athr/features/qebla/presentation/views/painters/painters.dart';
import 'package:athr/features/qebla/presentation/views/widgets/big_arrow_widget.dart';
import 'package:athr/features/qebla/presentation/views/widgets/compass_widget.dart';
import 'package:athr/features/qebla/presentation/views/widgets/qibla_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';



class QiblaView extends StatefulWidget {
  const QiblaView({super.key});

  @override
  State<QiblaView> createState() => _QiblaViewState();
}

class _QiblaViewState extends State<QiblaView> with TickerProviderStateMixin {
  final _dateFormat = DateFormat('EEEE، d MMMM', 'ar');
  Future<bool>? _deviceSupport;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  late AnimationController _arrowRotationController;
  late Animation<double> _arrowRotationAnimation;

  double _currentNeedleAngle = 0.0;
  double _targetNeedleAngle  = 0.0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _arrowRotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _arrowRotationAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(parent: _arrowRotationController, curve: Curves.easeOut),
    );

    _init();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _arrowRotationController.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    await _requestPermissions();
    final support = await FlutterQiblah.androidDeviceSensorSupport() ?? false;
  if (mounted) {
  setState(() {
    _deviceSupport = Future.value(support);
  });
}
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.locationWhenInUse.request();
    if (status.isPermanentlyDenied) openAppSettings();
  }

  void _updateNeedleAngle(double newAngle) {
    double diff = newAngle - _currentNeedleAngle;
    while (diff > pi) diff -= 2 * pi;
    while (diff < -pi) diff += 2 * pi;

    _targetNeedleAngle = _currentNeedleAngle + diff;

    _arrowRotationAnimation = Tween<double>(
      begin: _currentNeedleAngle,
      end: _targetNeedleAngle,
    ).animate(CurvedAnimation(parent: _arrowRotationController, curve: Curves.easeOut));

    _arrowRotationController.forward(from: 0).then((_) {
      if (mounted) _currentNeedleAngle = _targetNeedleAngle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: IslamicPatternPainter())),
          SafeArea(
            child: _deviceSupport == null
                ? _loadingWidget()
                : FutureBuilder<bool>(
                    future: _deviceSupport,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return _loadingWidget();
                      if (!(snapshot.data ?? false)) return _unsupportedWidget();
                      return StreamBuilder<QiblahDirection>(
                        stream: FlutterQiblah.qiblahStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return _loadingWidget();
                          final qiblah = snapshot.data!;
                          final needleRad = (qiblah.qiblah - qiblah.direction) * (pi / 180);
                          _updateNeedleAngle(needleRad);
                          return _buildUI(qiblah);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Column(
        children: [
          Text(
            'اتجاه القبلة',
            style: TextStyle(
              color: AppColors.gold,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          Text(
            _dateFormat.format(DateTime.now()),
            style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildUI(QiblahDirection qiblah) {
    final compassAngle = -qiblah.direction * (pi / 180);
    final offset       = qiblah.offset.abs();
    final isAligned    = offset < 5;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 12),
            DegreeCard(
              degree: qiblah.qiblah,
              isAligned: isAligned,
              pulseAnimation: _pulseAnimation,
            ),
            const SizedBox(height: 24),
            BigArrowWidget(
              isAligned: isAligned,
              pulseAnimation: _pulseAnimation,
              rotationController: _arrowRotationController,
              rotationAnimation: _arrowRotationAnimation,
            ),
            const SizedBox(height: 24),
            CompassWidget(compassAngle: compassAngle, isAligned: isAligned),
            const SizedBox(height: 24),
            StatusBanner(isAligned: isAligned, offset: offset),
            const SizedBox(height: 16),
            InfoRow(qiblah: qiblah, isAligned: isAligned),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _loadingWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(color: AppColors.gold, strokeWidth: 2),
          ),
          const SizedBox(height: 16),
          Text(
            'جاري تحديد اتجاه القبلة...',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _unsupportedWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.sensors_off_rounded, color: AppColors.gold, size: 48),
          const SizedBox(height: 16),
          Text('الجهاز لا يدعم البوصلة', style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            'يرجى استخدام جهاز يحتوي على حساس مغناطيسي',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
