import 'dart:convert';
import 'dart:io';

import 'package:dsx/events/RouteGenerator.dart';
import 'package:dsx/utils/device_info.dart';
import 'package:dsx/utils/jwt_token.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Request {
  static const jsonHeader = {"Content-Type": "application/json"};

  Future createPost(String url, {Map body, Map headers}) async {
    var jsonBody = json.encode(body);
    var response = await http
        .post(url, headers: headers, body: jsonBody)
        .timeout(Duration(seconds: 5));

    return response;
  }

  Future<Response> createGet(String url, {Map headers}) async {
    var response =
        http.get(url, headers: headers).timeout(Duration(seconds: 5));
    return response;
  }

  Future<Response> createPut(String url, {Map body, Map headers}) async {
    var jsonBody = json.encode(body);
    var response = http
        .put(url, headers: headers, body: jsonBody)
        .timeout(Duration(seconds: 5));
    return response;
  }

  Future<Response> createDelete(String url, {Map headers}) async {
    var response =
        http.delete(url, headers: headers).timeout(Duration(seconds: 5));
    return response;
  }

  Future<Response> getToMobileApi(
      {String resourcePath, Map additionalHeaders}) async {
    var headers = await _createHeaders();
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    var response =
        await this.createGet(_getUrl(resourcePath), headers: headers);
    if (response.statusCode == HttpStatus.unauthorized) {
      _handleUnauthorized();
    }

    return response;
  }

  Future<Response> postToMobileApi(
      {String resourcePath, Map body, Map additionalHeaders}) async {
    var headers = await _getHeaders(additionalHeaders);
    var response = await this
        .createPost(_getUrl(resourcePath), body: body, headers: headers);
    if (response.statusCode == HttpStatus.unauthorized) {
      _handleUnauthorized();
    }

    return response;
  }

  Future<Response> putToMobileApi(
      {String resourcePath, Map body, Map additionalHeaders}) async {
    var headers = await _getHeaders(additionalHeaders);

    var response = await this
        .createPut(_getUrl(resourcePath), body: body, headers: headers);
    if (response.statusCode == HttpStatus.unauthorized) {
      _handleUnauthorized();
    }

    return response;
  }

  Future<Response> deleteToMobileApi(String url,
      {Map additionalHeaders}) async {
    var headers = await _getHeaders(additionalHeaders);
    var response = await this.createDelete(_getUrl(url), headers: headers);
    if (response.statusCode == HttpStatus.unauthorized) {
      _handleUnauthorized();
    }

    return response;
  }

  Future<Response> multiPartPostToMobileApi(
      {String resourcePath, File file, Map additionalHeaders}) async {
    var headers = await _createHeaders()
      ..addAll(additionalHeaders ?? Map<String, String>());

    var uri = Uri.parse(_getUrl(resourcePath));
    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..files.add(MultipartFile.fromBytes("file", file.readAsBytesSync(),
          filename: "file"));

    var streamedResponse = await request.send();
    return http.Response.fromStream(streamedResponse);
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

  Future<Map> _createHeaders() async {
    return await DeviceInfo().getInfoHeader()
      ..addAll(await JwtTokenUtils().getTokenHeader())..addAll(jsonHeader);
  }

  String _getUrl(String resourcePath) {
    return '${GlobalConfiguration().getString("baseUrl")}$resourcePath';
  }

  Future<Map<String, String>> _getHeaders(var additionalHeaders) async {
    var headers = await _createHeaders();
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  _handleUnauthorized() {
    print("unauthorized");
    RouteGenerator.generateRoute(RouteSettings(name: '/'));
  }
}
