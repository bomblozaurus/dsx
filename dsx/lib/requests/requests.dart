import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
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

  Future createGet (String url, {Map body, Map headers}) async  {

    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String deviceInfo;
    try{
      if (Platform.isAndroid) {
        try {
          deviceInfo =  deviceInfoPlugin.androidInfo.toString();
        } on Exception catch(e) {}

      } else if (Platform.isIOS) {
        deviceInfo =  deviceInfoPlugin.iosInfo.toString();
      }
    }on Exception catch(e)
    {

    }
    var h1 = {"Device-info":deviceInfo};
    headers.addAll(h1);

    var toReturn;
    await http
        .get(url, headers: headers)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400) {
        throw new Exception("WQYWALILO SIE" + statusCode.toString()  + headers.toString()+ response.body);
      }
      toReturn = response.body;
    });
    return toReturn;
  }
}
