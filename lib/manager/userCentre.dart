import 'dart:convert';

import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/tools.dart';

import '../config.dart';

class UserCentre {
  static MyProfile? _info;
  static String? _token;

  static MyProfile? getInfo() {
    if (_info == null) {
      _info =
          MyProfile.fromJson(jsonDecode(SP.getString(SPKey.userInfo))['info']);
    }
    return _info;
  }

  static String getToken() {
    if (_token == null) {
      var userInfoData = SP.getString(SPKey.userInfo);
      if (userInfoData != null) {
        _token = jsonDecode(userInfoData)['token'];
      }
    }
    return _token ?? "";
  }

  static void saveUserInfo(String data) {
    SP.set(SPKey.userInfo, data);
    _info = MyProfile.fromJson(jsonDecode(data)['info']);
  }

  static bool isLogin() {
    var tmp = getToken();
    return tmp != "";
  }

  static void logout() {
    SP.delete(SPKey.userInfo);
    _info = null;
    _token = null;
  }
}
