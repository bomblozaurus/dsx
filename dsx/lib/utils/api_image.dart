import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dsx/style/theme.dart' as Theme;
import 'package:dsx/utils/device_info.dart';
import 'package:dsx/utils/jwt_token.dart';
import 'package:dsx/utils/requests.dart' as Request;
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

class ApiImage extends Image {
  static Widget getCircleAvatar({String url, double radius}) {
    return FutureBuilder(
      future: _getNetworkImage(url),
      builder: (BuildContext context,
          AsyncSnapshot<CachedNetworkImageProvider> snapshot) {
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

  static Future<int> uploadImage(File file) async {
    String resourcePath = GlobalConfiguration().getString("uploadImageUrl");
    int id;
    await Request.Request()
        .multiPartPostToMobileApi(resourcePath: resourcePath, file: file)
        .then((response) {
      if (response.statusCode == HttpStatus.ok) {
        var body = json.decode(utf8.decode(response.bodyBytes));
        id = body['id'] as int;
      }
    });
    return id;
  }

  static Future<CachedNetworkImageProvider> _getNetworkImage(String url) async {
    return CachedNetworkImageProvider(
      url,
      headers: await _getHeaders(),
    );
  }

  static Future<Map<String, String>> _getHeaders() async {
    return await JwtTokenUtils().getTokenHeader()
      ..addAll(await DeviceInfo().getInfoHeader());
  }
}
