import 'package:blackox/Login%20Screen/LoginScreen.dart';
import 'package:blackox/StartingScreens/letStartedScreen.dart';
import 'package:blackox/StartingScreens/startingScreen.dart';
import 'package:blackox/i18n/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Splash Screen/splashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('gu', ''),
        Locale('hi', ''),
        Locale('kn', ''),
        Locale('mr', ''),
      ],
      initialRoute: '/',
      title: 'Black OX',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      routes: {
        '/': (context) => const SplashScreen(),
        '/letStartedScreen': (context) => const LetStartedScreen(),
        '/startingScreen': (context) => StartingScreen(onLocaleChange: _setLocale),
        '/loginScreen':(context) => const LoginScreen(),
      },
    );
  }
}