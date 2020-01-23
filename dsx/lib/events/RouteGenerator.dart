import 'package:flutter/material.dart';

import '../ui/views/event_details_page.dart';
import '../ui/views/login_page.dart';
import '../ui/views/what_first.dart';
import 'RoutePages.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => WhatFirst());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/menu':
        return MaterialPageRoute(builder: (_) => FirstPage());
      case '/add':
        return MaterialPageRoute(
          builder: (_) => AddPage(),
        );
      case '/events':
        return MaterialPageRoute(
          builder: (_) => ShowScopePage(),
        );
      case '/eventDetails':
        {
          return MaterialPageRoute(
              builder: (_) => EventDetailsPage(event: args));
        }
      default:
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
