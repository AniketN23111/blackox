import 'package:flutter/material.dart';

import '../NavigatorHome/business_details_shops.dart';
import '../NavigatorHome/home_page.dart';

class HomeNavigator extends StatelessWidget {
  const HomeNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
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
    );
  }
}
