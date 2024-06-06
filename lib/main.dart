import 'package:blackox/Authentication%20Screen/signup_screen.dart';
import 'package:blackox/Constants/screen_utility.dart';
import 'package:blackox/Authentication Screen//authentication_screen.dart';
import 'package:blackox/StartingScreens/let_started_screen.dart';
import 'package:blackox/StartingScreens/starting_screen.dart';
import 'package:blackox/i18n/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Splash Screen/splash_screen.dart';

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
      builder: (context, child) {
        Screen_utility.init(context);
        return child!;
      },
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
        '/authenticationScreen': (context) => const AuthenticationScreen(),
        '/signUpScreen': (context) => const SignUpScreen(),
      },
    );
  }
}
