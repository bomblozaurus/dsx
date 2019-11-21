import 'package:dsx/ui/login_page.dart';
import 'package:dsx/ui/menu.dart';
import 'package:dsx/utils/jwt_token.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: JwtTokenUtils().getToken(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return new MenuPage();
        } else {
          return new LoginPage();
        }
      },
    );
  }
}
