import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info/package_info.dart';

import '../common/tools.dart';
import '../config.dart';

class DeviceInfo {
  static final info = <String, String>{};
  static String platformName = "";

  static Future init() async {
    if (info.isEmpty) {
      var deviceInfo = DeviceInfo();
      //info为空，初始化info内容. 先读取SP
      var storedMap = deviceInfo.readSp();
      if (storedMap.isNotEmpty) {
        //使用SP中的值
        info.addAll(storedMap);
      } else {
        //生成info
        var newInfo = await deviceInfo.createInfo();
        info.addAll(newInfo);
        //写入SP
        deviceInfo.writeSp(newInfo);
      }
    }
  }

  //从SP读取缓存的值。
  Map<String, String> readSp() {
    try {
      var stored = SP.getString(SPKey.COMMON_PARAM_KEY);
      if (stored != null) {
        Map<String, String>? storedMap = jsonDecode(stored);
        if (storedMap?.isNotEmpty ?? false) {
          return storedMap!;
        }
      }
    } catch (e) {}
    return <String, String>{};
  }

  writeSp(Map<String, String> data) {
    try {
      SP.set(SPKey.COMMON_PARAM_KEY, jsonEncode(data));
    } catch (e) {}
  }

  Future<Map<String, String>> createInfo() async {
    var _commonParamMap = <String, String>{};
    var deviceInfo = DeviceInfoPlugin();
    var packageInfo = await PackageInfo.fromPlatform();
    if (Platform.isAndroid) {
      platformName = "ANDROID";
      AndroidDeviceInfo info = await deviceInfo.androidInfo;
      _commonParamMap.addAll({
        "device_model": info.model ?? "",
        "phone_board": info.brand ?? "",
        "version": packageInfo.version,
        "vc": packageInfo.buildNumber,
        "package_name": packageInfo.packageName,
        "system_version": info.version.release ?? "",
        "android_id": info.androidId ?? "",
        "isPhysicalDevice": info.isPhysicalDevice ?? true ? "1" : "0",
        "os": "ANDROID"
      });
    } else if (Platform.isIOS) {
      platformName = "IOS";
      IosDeviceInfo info = await deviceInfo.iosInfo;
      _commonParamMap.addAll({
        "device_model": info.utsname.machine ?? "",
        "phone_board": info.model ?? "",
        "version": packageInfo.version,
        "vc": packageInfo.buildNumber,
        "package_name": packageInfo.packageName,
        "system_version": info.systemVersion ?? "",
        "IDFV": info.identifierForVendor ?? "",
        "isPhysicalDevice": info.isPhysicalDevice ? "1" : "0",
        "os": "IOS"
      });
    } else if (Platform.isWindows) {
    } else if (Platform.isMacOS) {}
    return _commonParamMap;
  }
}
