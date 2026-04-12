import 'package:athr/core/services/shared_prefrence.dart';
import 'package:athr/features/splash/presentation/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  runApp(const Athr());
    WidgetsFlutterBinding.ensureInitialized();
  await Prefs.init();
  }

class Athr extends StatelessWidget {
  const Athr({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales:const [   // Languages that will be supported
     Locale('en'),
     Locale('ar'),
      ],
      localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  locale: const Locale('ar'), // Default language
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'cairo',scaffoldBackgroundColor: Colors.white),
      home: const SplashView(),
    );
  }
}
