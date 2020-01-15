import 'package:dsx/utils/device_info.dart';
import 'package:dsx/utils/jwt_token.dart';
import 'package:flutter/material.dart';

class ApiImage extends Image {
  Future<Map<String, String>> _getHeaders() async {
    return await JwtTokenUtils().getTokenHeader()
      ..addAll(await DeviceInfo().getInfoHeader());
  }
}
