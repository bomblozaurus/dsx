import 'package:dsx/style/theme.dart' as Theme;
import 'package:dsx/utils/device_info.dart';
import 'package:dsx/utils/jwt_token.dart';
import 'package:flutter/material.dart';

class ApiImage extends Image {
  static Widget getCircleAvatar({String url, double radius}) {
    return FutureBuilder(
      future: _getNetworkImage(url),
      builder: (BuildContext context, AsyncSnapshot<NetworkImage> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CircleAvatar(
            backgroundImage: snapshot.data,
            radius: radius,
          );
        } else
          return CircleAvatar(
            child: CircularProgressIndicator(
              backgroundColor: Theme.Colors.logoBackgroundColor,
            ),
            radius: radius,
            backgroundColor: Theme.Colors.loginGradientEnd,
          );
      },
    );
  }

  static Widget getImage({String url, BoxFit fit}) {
    return FutureBuilder(
      future: _getHeaders(),
      builder:
          (BuildContext builder, AsyncSnapshot<Map<String, String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Image.network(url, headers: snapshot.data, fit: fit);
        }

        return Container(
          color: Theme.Colors.loginGradientEnd,
        );
      },
    );
  }

  static Future<NetworkImage> _getNetworkImage(String url) async {
    return NetworkImage(
      url,
      headers: await _getHeaders(),
    );
  }

  static Future<Map<String, String>> _getHeaders() async {
    return await JwtTokenUtils().getTokenHeader()
      ..addAll(await DeviceInfo().getInfoHeader());
  }
}
