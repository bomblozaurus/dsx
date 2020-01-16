import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

import 'events/RouteGenerator.dart';
import 'style/theme.dart' as Theme;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("api_urls");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DSX',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(),
        primaryColor: Theme.Colors.loginGradientEnd,
      ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
