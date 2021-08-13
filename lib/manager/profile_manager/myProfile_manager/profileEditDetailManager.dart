import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/config.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/manager/userCentre.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/common/utils.dart';

class ProfileEditDetailManager extends ChangeNotifier {
  String? keyName;

  /// 初始化
  init() {}

  void setKeyName(String info) {
    switch (info) {
      case '昵称':
        keyName = 'nickName';
        break;
      case '个人简介':
        keyName = 'notes';
        break;
      case '手机号':
        keyName = 'phone';
        break;
      case '电子邮箱':
        keyName = 'email';
        break;
      case '地址':
        keyName = 'address';
        break;
    }
  }

  Future<dynamic> updateProfileData(String? value) async {
    if (keyName != null && value != null) {
      ApiResult result = await API.updateProfileData(keyName!, value);
      if (result.isSuccess()) {
        _getStoredForMyProfileData().then((value) {
          value['info'].addAll(result.getData());
          print("DEBUG=> value result.getData() ${value['info']}");
          // SP.set(SPKey.userInfo, jsonEncode(value));
          UserCentre.saveUserInfo(jsonEncode(value));
        });

        Future.delayed(Duration(milliseconds: 500), () {
          Navigator.of(App.navState.currentContext!).pop(true);
        });
      } else {
        showToast('${result.info}');
      }
    } else {
      print("DEBUG=> keyName $keyName");
      print("DEBUG=> value $value");
      showToast('输入的内容不能为空');
    }
  }

  Future _getStoredForMyProfileData() async {
    String? stored = SP.getString(SPKey.userInfo);
    if (stored != null) {
      print("_myProfileData ${stored}");
      try {
        return jsonDecode(stored);
      } catch (e) {}
    } else {
      showToast('请重新登录');
      SP.delete(SPKey.userInfo);
      Future.delayed(
          Duration(seconds: 1), () => Routers.navigateAndRemoveUntil('/login'));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
