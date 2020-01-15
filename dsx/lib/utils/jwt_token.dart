import 'dart:convert';

import 'package:dsx/models/user_details.dart';
import 'package:dsx/models/user_roles.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JwtTokenUtils {
  static final _storage = FlutterSecureStorage();
  static const _key = "jwtToken";

  Future<String> getToken() async {
    String token = await _storage.read(key: _key);
    return token;
  }

  saveToken(String token) {
    _storage.write(key: _key, value: token);
  }

  Future<UserDetails> getUserDetails() async {
    return UserDetails.fromJson(await _getData());
  }

  Future<bool> isUser() async {
    return await getRoles().then((roles) => roles.contains(UserRole.USER.role));
  }

  Future<Map<String, String>> getTokenHeader() async {
    var token = await this.getToken();
    return {"Authorization": "Bearer $token"};
  }

  Future<List<String>> getRoles() async {
    return await _getData().then((map) => map['role'].split(','));
  }

  Future<Map<String, dynamic>> _getData() async {
    var bodyMap;
    await getToken().then((token) {
      var claims = token.split('.');
      assert(claims.length >= 1);
      var body = _encodeClaim(claims[1]);
      bodyMap = json.decode(body);
    });

    return bodyMap;
  }

  _encodeClaim(String claim) {
    String normalizedClaim = base64Url.normalize(claim);
    return utf8.decode(base64.decode(normalizedClaim));
  }
}
