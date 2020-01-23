import 'package:dsx/models/user_details.dart';
import 'package:dsx/utils/jwt_token.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main_page.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureProvider<UserDetails>(
      child: MainPage(),
      create: (BuildContext context) async {
        return await JwtTokenUtils().getUserDetails();
      },
    );
  }
}
