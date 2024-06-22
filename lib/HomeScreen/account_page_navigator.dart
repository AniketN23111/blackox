import 'package:blackox/Navigator/NavigatorAccountPage/account_page.dart';
import 'package:flutter/material.dart';

class AccountPageNavigator extends StatelessWidget {
  const AccountPageNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: 'account',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case 'account':
            builder = (BuildContext context) => const AccountPage();
            break;
          /*case 'businessDetailsShops':
            builder = (BuildContext context) => const BusinessDetailsShops();
            break;*/
        // Add more routes here as needed
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
