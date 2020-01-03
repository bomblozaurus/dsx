import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

import 'style/theme.dart' as Theme;
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
        colorScheme: ColorScheme.dark(),
        primaryColor: Theme.Colors.loginGradientEnd,

      ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
