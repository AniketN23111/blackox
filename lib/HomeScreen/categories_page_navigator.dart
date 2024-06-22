import 'package:blackox/NavigatorCategories/categories_page.dart';
import 'package:flutter/material.dart';

class CategoriesPageNavigator extends StatelessWidget {
  const CategoriesPageNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: 'category',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case 'category':
            builder = (BuildContext context) => const CategoriesPage();
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
