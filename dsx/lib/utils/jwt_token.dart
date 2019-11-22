import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JwtTokenUtils {
  static final _storage = new FlutterSecureStorage();
  static const _key = "jwtToken";

  Future<String> getToken() async {
    String token = await _storage.read(key: _key);
    return token;
  }

  saveToken(String token) {
    _storage.write(key: _key, value: token);
  }

   Future<Map<String, String>> getTokenHeader() async{
    var token = await this.getToken();
    return {"Authorization": token};
  }
}
