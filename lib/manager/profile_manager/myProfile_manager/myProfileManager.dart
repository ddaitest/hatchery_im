import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/common/log.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/manager/userCentre.dart';
import 'package:hatchery_im/common/utils.dart';

import '../../settingCentre.dart';

class MyProfileManager extends ChangeNotifier {
  MyProfile? myProfileData;
  String cacheSize = "";

  /// 初始化
  MyProfileManager() {
    _getStoredForMyProfileData();
    checkCacheSize();
    Log.green("settingConfigInfo ${SettingCentre.settingConfigInfo?.mute}");
  }

  void refreshData() {
    _getStoredForMyProfileData();
  }

  checkCacheSize() {
    CacheInfo().loadCache().then((value) {
      cacheSize = value;
      notifyListeners();
    });
  }

  deleteCacheData() {
    CacheInfo().clearCache();
    cacheSize = "0.00B";
    notifyListeners();
  }

  _getStoredForMyProfileData() async {
    myProfileData = UserCentre.getInfo();
    if (myProfileData != null) {
      print("_myProfileData ${myProfileData!.loginName}");
      notifyListeners();
    } else {
      showToast('请重新登录');
      UserCentre.logout();
      Future.delayed(Duration(milliseconds: 1500),
          () => Routers.navigateAndRemoveUntil('/login'));
    }
  }

  logOutMethod() {
    UserCentre.logout();
    Routers.navigateAndRemoveUntil('/login');
  }

  @override
  void dispose() {
    super.dispose();
  }
}
