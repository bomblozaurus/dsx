import 'package:dsx/ui/events_page.dart';
import 'package:dsx/ui/first_screen.dart';
import 'package:dsx/ui/login_page.dart';
import 'package:dsx/ui/menu.dart';
import 'package:dsx/ui/rooms_page.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("api_urls");
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'DSX',
      theme: new ThemeData(
        primarySwatch: Colors.lime,
      ),
      initialRoute: '/',
      routes: {
        "/": (context) => FirstPage(),
        "/MenuPage": (context) => MenuPage(),
        "/RoomsPage": (context) => RoomsPage(),
        "/EventsPage": (context) => EventsPage()
      },
    );
  }
}
