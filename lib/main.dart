import 'package:athr/core/services/prayer_time_service.dart';
import 'package:athr/core/services/shared_prefrence.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Prefs.init(); // initialize shared Preference

  runApp(const AthrApp());
}

class AthrApp extends StatelessWidget {
  const AthrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LocaleCubit()),  // cubit for Language
        BlocProvider(
          create: (_) => PrayerTimeCubit(   // cubit for Prayers Time
            InitialPrayerTimeState(),
            prayerTimeRepo: PrayerTimeRepoImpl(
              prayerTimeService: PrayerTimeService(dio: Dio()),
            ),
          ),
        ),
      ],
      child: DevicePreview(enabled: false, builder: (context) => const Athr()),
    );
  }
}

class Athr extends StatelessWidget {
  const Athr({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
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
    );
  }
}
