import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

import 'events/RouteGenerator.dart';

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
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
