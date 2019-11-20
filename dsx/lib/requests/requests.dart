import 'dart:convert';

import 'package:http/http.dart' as http;

class Request {
  static const jsonHeader = {"Content-Type": "application/json"};

  Future createPost(String url, {Map body, Map headers}) async {
    var jsonBody = json.encode(body);
    var toReturn;
    await http
        .post(url, headers: headers, body: jsonBody)
        .then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        throw new Exception("WQYWALILO SIE" + response.body);
      }

      toReturn = response.body;
    });

    return toReturn;
  }

  Future createGet(String url, {Map body, Map headers}) async {
    var toReturn;
    await http
        .get(url, headers: headers)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400) {
        throw new Exception("WQYWALILO SIE" + response.body);
      }
      toReturn = response.body;
    });
    return toReturn;
  }
}
