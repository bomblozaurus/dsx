import 'dart:convert';

import 'package:http/http.dart' as http;

class Request{
  Future<dynamic> createPost(String url, {Map body}) async {
    var jsonBody = json.encode(body);
    http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonBody).then((http.Response response){
      final int statusCode = response.statusCode;

      if(statusCode < 200 || statusCode > 400 ){
          throw new Exception("WQYWALILO SIE" + response.body);
      }

      return response.body;
    });
  }
}