import 'dart:convert';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/common/utils.dart';
import '../config.dart';
import '../routers.dart';

class UserCentre {
  static MyProfile? _info;
  static String? _token;
  static String? _userID;
  static String? _nickName;

  static MyProfile? getInfo() {
    String? userInfoSP = SP.getString(SPKey.userInfo);
    if (userInfoSP != null) {
      if (_info == null) {
        _info = MyProfile.fromJson(jsonDecode(userInfoSP)['info']);
      }
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

  static String getUserID() {
    if (_info != null) {
      _userID = _info!.userID;
    }
    return _userID ?? "";
  }

  String getNickName() {
    if (_info != null) {
      _nickName = _info!.nickName;
    }
    return _nickName ?? "";
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
