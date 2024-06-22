import 'package:blackox/NavigatorAddPage/add_page.dart';
import 'package:flutter/material.dart';

class AddPageNavigator extends StatelessWidget {
  const AddPageNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: 'add',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case 'add':
            builder = (BuildContext context) => const AddPage();
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
