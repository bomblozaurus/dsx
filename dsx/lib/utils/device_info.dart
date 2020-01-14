import 'dart:io';

import 'package:device_info/device_info.dart';

class DeviceInfo {
  Future<String> getInfo() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String deviceInfo;
    if (Platform.isAndroid) {
      await deviceInfoPlugin.androidInfo
          .then((e) => deviceInfo = _readAndroidInfo(e));
    } else if (Platform.isIOS) {
      await deviceInfoPlugin.iosInfo.then((e) => deviceInfo = _readIosInfo(e));
    }

    return deviceInfo;
  }

  Future<Map<String,String>> getInfoHeader() async {
    return {"Device-info": await this.getInfo()};
  }

  String _readAndroidInfo(AndroidDeviceInfo info) {
    return '${info.androidId}, ${info.model}, ${info.manufacturer}, ${info.isPhysicalDevice}, ${info.product}';
  }

  String _readIosInfo(IosDeviceInfo info) {
    return '$info.systemName, $info.systemVersion, $info.model, $info.name, $info.isPhysicalDevice';
  }
}
