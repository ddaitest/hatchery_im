import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/config.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/common/utils.dart';

class MyProfileManager extends ChangeNotifier {
  MyProfile? myProfileData;

  /// 初始化
  MyProfileManager() {
    _getStoredForMyProfileData();
  }

  _getStoredForMyProfileData() async {
    String? stored = SP.getString(SPKey.userInfo);
    if (stored != null) {
      print("_myProfileData ${stored}");
      try {
        var userInfo = MyProfile.fromJson(jsonDecode(stored)['info']);
        myProfileData = userInfo;
        print("_myProfileData ${myProfileData!.icon}");
        notifyListeners();
      } catch (e) {}
    } else {
      showToast('请重新登录');
      SP.delete(SPKey.userInfo);
      Future.delayed(
          Duration(seconds: 1), () => Routers.navigateAndRemoveUntil('/login'));
    }
  }

  logOut() {
    SP.delete(SPKey.userInfo);
    Future.delayed(
        Duration.zero, () => Routers.navigateAndRemoveUntil('/login'));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
