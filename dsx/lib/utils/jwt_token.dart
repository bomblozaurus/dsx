import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JwtTokenUtils{
  static final _storage = new FlutterSecureStorage();
  static const _key = "jwtToken";

  getToken(){
    return _storage.read(key: _key);
  }

  saveToken(String token){
    _storage.write(key: _key, value: token);
  }
}