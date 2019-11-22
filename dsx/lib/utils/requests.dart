import 'dart:convert';

import 'package:dsx/utils/device_info.dart';
import 'package:dsx/utils/jwt_token.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

class Request {
  static const jsonHeader = {"Content-Type": "application/json"};

  Future createPost(String url, {Map body, Map headers}) async {
    var jsonBody = json.encode(body);
    var response = await http.post(url, headers: headers, body: jsonBody);

    return response;
  }

  Future createGet(String url, {Map headers}) async {
    var toReturn =  http.get(url, headers: headers);

    return toReturn;
  }

  Future getToMobileApi(
      {String resourcePath, Map additionalHeaders}) async {
    var headers = await _createGetHeaders();
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return await this.createGet(_getUrl(resourcePath), headers: headers);
  }

  Future postToMobileApi(
      {String resourcePath, Map body, Map additionalHeaders}) async {
    var headers = await _createGetHeaders();
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return await this
        .createPost(_getUrl(resourcePath), body: body, headers: headers);
  }

  Future postToMobileApiWithoutTokenHeader(
      {String resourcePath, Map body, Map additionalHeaders}) async {
    Map<String, String> headers = await DeviceInfo().getInfoHeader()
      ..addAll(jsonHeader);
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return await this
        .createPost(_getUrl(resourcePath), body: body, headers: headers);
  }

  Future<Map> _createGetHeaders() async {
    return await DeviceInfo().getInfoHeader()
      ..addAll(await JwtTokenUtils().getTokenHeader())
      ..addAll(jsonHeader);
  }

  String _getUrl(String resourcePath) {
    return GlobalConfiguration().getString("baseUrl") + resourcePath;
  }
}
