import 'package:athr/core/services/shared_prefrence.dart';
import 'package:athr/features/language&location/presentation/manager/locale_cubit.dart';
import 'package:athr/features/splash/presentation/views/splash_view.dart';
import 'package:athr/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  runApp(BlocProvider(
    create: (context) => LocaleCubit(),
    child: const Athr()));
    WidgetsFlutterBinding.ensureInitialized();
  await Prefs.init();
  }

class Athr extends StatelessWidget {
  const Athr({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
         builder: (context,locale) => MaterialApp(
          locale: locale,
           supportedLocales: AppLocalizations.supportedLocales,

  localizationsDelegates: AppLocalizations.localizationsDelegates,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'cairo',scaffoldBackgroundColor: Color(0xffF5F4F1)),
        home: const SplashView(),
      ),
    );
  }
}
