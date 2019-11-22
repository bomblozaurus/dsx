import 'dart:io';

import 'package:dsx/utils/requests.dart';
import 'package:dsx/style/theme.dart' as Theme;
import 'package:dsx/ui/login_page.dart';
import 'package:dsx/ui/menu.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

class WhatFirst extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: this.verifyToken(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return _splashScreen();
          if (snapshot.hasData && snapshot.data == HttpStatus.ok) {
            return MenuPage();
          }
          return LoginPage();
        });
  }

  Future<int> verifyToken() async {
    String resourcePath = GlobalConfiguration().getString("verifyTokenUrl");
    try {
      await Request().getToMobileApi(resourcePath: resourcePath);
      return 200;
    } catch (statusCodeException) {
      return -1;
    }
  }
}

Widget _splashScreen() {
  return new Container(
    decoration: BoxDecoration(gradient: Theme.Colors.primaryGradient),
  );
}
