import 'package:dsx/events/create_event_page2.dart';
import 'package:dsx/events/show_event_page.dart';
import 'package:dsx/ui/login_page.dart';
import 'package:flutter/material.dart';

import 'RoutePages.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/menu':
        return MaterialPageRoute(builder: (_) => FirstPage());
      case '/add':
    // Validation of correct data type
        return MaterialPageRoute(
          builder: (_) => AddPage(),
        );
      // If args is not of the correct type, return an error page.
      // You can also throw an exception while in development.
      return _errorRoute();
      case '/addEvent':
      // Validation of correct data type
          return MaterialPageRoute(
            builder: (_) => CreateEventPage(),
          );
          case '/events':
            return MaterialPageRoute(
              builder: (_) => ShowScopePage(),
            );
      case '/scope':
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => ShowEventsPage(
              scope: args,
            ),
          );
        }
        return _errorRoute();
      default:
      // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}