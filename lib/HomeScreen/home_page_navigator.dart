import 'package:flutter/material.dart';

import '../Navigator/NavigatorHome/business_details_shops.dart';
import '../Navigator/NavigatorHome/home_page.dart';

class HomeNavigator extends StatelessWidget {
  const HomeNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop:false,
          onPopInvoked: (onPop) async {
        Navigator.of(context).pushReplacementNamed('home');
        return;
      },
      child: Navigator(
        initialRoute: 'home',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case 'home':
              builder = (BuildContext context) => const HomePage();
              break;
            case 'businessDetailsShops':
              builder = (BuildContext context) => const BusinessDetailsShops();
              break;
          // Add more routes here as needed
            default:
              throw Exception('Invalid route: ${settings.name}');
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        },
      ),
    );
  }
}
