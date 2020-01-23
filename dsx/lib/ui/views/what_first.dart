import 'dart:io';

import 'package:dsx/style/theme.dart' as Theme;
import 'package:dsx/utils/requests.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

import 'landing_page.dart';
import 'login_page.dart';

class WhatFirst extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: this.verifyToken(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return _splashScreen();
          if (snapshot.hasData && snapshot.data == HttpStatus.ok) {
            return LandingPage();
          }
          return LoginPage();
        });
  }

  Future<int> verifyToken() async {
    String resourcePath = GlobalConfiguration().getString("verifyTokenUrl");
    try {
      int responseCode;
      await Request()
          .getToMobileApi(resourcePath: resourcePath)
          .then((response) => responseCode = response.statusCode);
      return responseCode;
    } catch (statusCodeException) {
      return -1;
    }
  }
}

Widget _splashScreen() {
  return Container(
    decoration: BoxDecoration(gradient: Theme.Colors.primaryGradient),
  );
}
