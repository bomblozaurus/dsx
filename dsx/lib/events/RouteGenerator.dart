import 'package:dsx/events/create_event_page2.dart';
import 'package:dsx/events/show_event_page.dart';
import 'package:dsx/ui/login_page.dart';
import 'package:dsx/ui/what_first.dart';
import 'package:flutter/material.dart';

import 'RoutePages.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/': return MaterialPageRoute(builder: (_) => WhatFirst());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/menu':
        return MaterialPageRoute(builder: (_) => FirstPage());
      case '/add':
        return MaterialPageRoute(
          builder: (_) => AddPage(),
        );
      case '/addEvent':
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