import 'package:athr/core/services/adhan_audio_service.dart';
import 'package:athr/core/services/adhan_forground_service.dart';
import 'package:athr/core/services/notification_service.dart';
import 'package:athr/core/services/prayer_time_service.dart';
import 'package:athr/core/services/shared_prefrence.dart';
import 'package:athr/features/azan/presentation/manager/cubits/adhan_cubit.dart';
import 'package:athr/features/home/data/repos/prayer_time_repo_impl.dart';
import 'package:athr/features/home/presentation/manager/cubits/prayer_time_cubit.dart/prayer_time_cubit.dart';
import 'package:athr/features/home/presentation/manager/cubits/prayer_time_cubit.dart/prayer_time_states.dart';
import 'package:athr/features/languageAndlocation/presentation/manager/locale_cubit.dart';
import 'package:athr/features/splash/presentation/views/splash_view.dart';
import 'package:athr/l10n/app_localizations.dart';
import 'package:device_preview/device_preview.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Prefs.init();
  await Hive.initFlutter();
  await Hive.openBox('reminders');

  await AdhanForegroundService.init();
  await NotificationService.instance.init();
  await AdhanAudioService().init();

  runApp(const AthrApp());
}

class AthrApp extends StatelessWidget {
  const AthrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LocaleCubit()),
        BlocProvider(
          create: (_) => PrayerTimeCubit(
            InitialPrayerTimeState(),
            prayerTimeRepo: PrayerTimeRepoImpl(
              prayerTimeService: PrayerTimeService(dio: Dio()),
            ),
          ),
        ),
        // ✅ AdhanCubit هنا عشان يفضل شغال طول عمر التطبيق
        // ويستقبل رسائل الـ FG service حتى لو AzanView مش مفتوحة
        BlocProvider(create: (_) => AdhanCubit()),
      ],
      child: DevicePreview(enabled: false, builder: (context) => const Athr()),
    );
  }
}

class Athr extends StatelessWidget {
  const Athr({super.key});

  @override
  Widget build(BuildContext context) {
    return WithForegroundTask(
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'cairo',
              scaffoldBackgroundColor: const Color(0xffF5F4F1),
            ),
            home: const SplashView(),
          );
        },
      ),
    );
  }
}