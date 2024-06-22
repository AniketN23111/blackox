import 'package:flutter/material.dart';
import '../Navigator/NavigatorNotification/notification_page.dart';

class NotificationPageNavigator extends StatelessWidget {
  const NotificationPageNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: 'notification',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case 'notification':
            builder = (BuildContext context) => const NotificationPage();
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
