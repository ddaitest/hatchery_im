import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/engine/entity.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info/device_info.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:crypto/crypto.dart';
import '../config.dart';
import 'package:video_compress/video_compress.dart';

Future<String> compressionImage(filePath) async {
  ImageProperties properties =
      await FlutterNativeImage.getImageProperties(filePath);
  final width = properties.width;
  final height = properties.height;
  if (width == null || height == null) {
    return filePath;
  } else {
    File compressedFile = await FlutterNativeImage.compressImage(filePath,
        quality: 60, // 默认70
        targetWidth: width,
        targetHeight: height);
    return compressedFile.path;
  }
}

Future<String> compressionVideo(filePath) async {
  // await VideoCompress.deleteAllCache();
  final MediaInfo? info = await VideoCompress.compressVideo(
    filePath,
    quality: VideoQuality.Res960x540Quality,
    deleteOrigin: false,
    includeAudio: true,
  );
  print("DEBUG=> ###### ${info!.path}");
  return info.path!;
}

class SP {
  static late SharedPreferences sp;

  static Future init() async {
    sp = await SharedPreferences.getInstance();
  }

  static set(String key, dynamic data) {
    switch (data.runtimeType) {
      case String:
        sp.setString(key, data);
        break;
      case bool:
        sp.setBool(key, data);
        break;
      case int:
        sp.setInt(key, data);
        break;
      case double:
        sp.setDouble(key, data);
        break;
      case List:
        sp.setStringList(key, data);
        break;
    }
  }

  static delete(String key) => sp.remove(key);

  static getString(String key) => sp.getString(key);

  static getBool(String key) => sp.getBool(key);

  static getDouble(String key) => sp.getDouble(key);

  static getInt(String key) => sp.getInt(key);

  static getStringList(String key) => sp.getStringList(key);
}

class DeviceInfo {
  static final info = <String, String>{};

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
      AndroidDeviceInfo info = await deviceInfo.androidInfo;
      _commonParamMap.addAll({
        "device_model": info.model,
        "phone_board": info.brand,
        "version": packageInfo.version,
        "vc": packageInfo.buildNumber,
        "package_name": packageInfo.packageName,
        "system_version": info.version.release,
        "android_id": info.androidId,
        "isPhysicalDevice": info.isPhysicalDevice ? "1" : "0"
      });
    } else {
      IosDeviceInfo info = await deviceInfo.iosInfo;
      _commonParamMap.addAll({
        "device_model": info.utsname.machine,
        "phone_board": info.model,
        "version": packageInfo.version,
        "vc": packageInfo.buildNumber,
        "package_name": packageInfo.packageName,
        "system_version": info.systemVersion,
        "IDFV": info.identifierForVendor,
        "isPhysicalDevice": info.isPhysicalDevice ? "1" : "0"
      });
    }
    return _commonParamMap;
  }
}

class UserId {
  static String id = "";

  static Future init() async {
    if (id.isEmpty) {
      var userId = UserId();
      //info为空，初始化info内容. 先读取SP
      var storedId = userId.readSp();
      if (storedId.isNotEmpty) {
        //使用SP中的值
        id = storedId;
      } else {
        //生成info
        id = await userId.createInfo();
        //写入SP
        userId.writeSp(id);
      }
    }
  }

  //从SP读取缓存的值。
  String readSp() {
    try {
      var stored = SP.getString(SPKey.USER_ID_KEY);
      return stored ?? "";
    } catch (e) {}
    return "";
  }

  writeSp(String value) {
    try {
      SP.set(SPKey.USER_ID_KEY, value);
    } catch (e) {}
  }

  createInfo() async {
    var _info = <String>[];
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await deviceInfo.androidInfo;
      _info = [
        info.hardware,
        info.androidId,
        info.board,
        info.brand,
        info.device,
        info.display,
        info.model,
        info.product,
      ];
    } else {
      IosDeviceInfo info = await deviceInfo.iosInfo;
      _info = [
        info.utsname.machine,
        info.model,
        info.systemVersion,
        info.identifierForVendor,
        info.isPhysicalDevice ? "1" : "0"
      ];
    }
    var result = md5.convert(utf8.encode(_info.toString())).toString();
    return result;
  }
}

class ModelHelper {
  static Message convertGroupMessage(CSSendGroupMessage msg) {
    int serverMsgId = 0;
    if (msg.serverMsgId != "") {
      try {
        serverMsgId = int.parse(msg.serverMsgId);
      } catch (e) {}
    }
    Message message = Message(
        serverMsgId,
        "GROUP",
        msg.msgId,
        msg.from,
        msg.nick,
        msg.groupId,
        msg.icon,
        msg.source,
        msg.content,
        msg.contentType,
        DateTime.now().toString(),
        "");
    return message;
  }

  static Message convertMessage(CSSendMessage msg) {
    int serverMsgId = 0;
    if (msg.serverMsgId != "") {
      try {
        serverMsgId = int.parse(msg.serverMsgId);
      } catch (e) {}
    }
    Message message = Message(
        serverMsgId,
        "CHAT",
        msg.msgId,
        msg.from,
        msg.nick,
        "",
        msg.icon,
        msg.source,
        msg.content,
        msg.contentType,
        DateTime.now().toString(),
        msg.to);
    return message;
  }
}
