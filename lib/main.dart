import 'package:blackox/HomeScreen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

import 'package:blackox/Authentication%20Screen/login_screen.dart';
import 'package:blackox/Authentication%20Screen/signup_screen.dart';
import 'package:blackox/Constants/screen_utility.dart';
import 'package:blackox/Authentication%20Screen/authentication_screen.dart';
import 'package:blackox/SelectionScreen/let_started_screen.dart';
import 'package:blackox/SelectionScreen/selection_screen.dart';
import 'package:blackox/i18n/app_localization.dart';
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
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Locale _locale = const Locale('en');

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
    // Add the back button interceptor on app start
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      builder: (context, child) {
        ScreenUtility.init(context);
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
      initialRoute: '/', // Ensure this matches your initial route
      title: 'Black OX',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // Consider whether you really need to use useMaterial3, as it's still experimental
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const SplashScreen(),
        '/letStartedScreen': (context) => const LetStartedScreen(),
        '/homeScreen': (context) => const HomeScreen(),
        '/selectionScreen': (context) => SelectionScreen(onLocaleChange: _setLocale),
        '/authenticationScreen': (context) => const AuthenticationScreen(),
        '/signUpScreen': (context) => const SignUpScreen(),
        '/loginScreen': (context) => const LoginScreen(),
      },
      onGenerateRoute: (settings) {
        // Handle dynamic route generation if needed
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Route not found!'),
            ),
          ),
        );
      },
    );
  }

  // Custom interceptor function for back button
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    // Handle back button interception logic
    String? currentRoute = ModalRoute.of(context)?.settings.name;

    if (currentRoute == '/businessDetailsShops') {
      // Navigate to '/homeScreen' when pressing back from '/businessDetailsShops'
      navigatorKey.currentState?.pushReplacementNamed('/home');
      return true; // Return true to stop the default back button action
    }
    return false;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }
}
