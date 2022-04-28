import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/backgroundListenModel.dart';
import 'package:hatchery_im/common/log.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/manager/userCentre.dart';
import 'package:hatchery_im/store/LocalStore.dart';

import '../../config.dart';
import '../devicesInfoCentre.dart';
import '../settingCentre.dart';

class AppManager extends ChangeNotifier {
  static CustomMenuInfo? customMenuInfo;
  static List<ServersAddressInfo>? socketServers;

  /// 初始化
  void init() {
    /// 此 强制竖屏 方法只支持Android ios通过Xcode打开Flutter项目中的iOS工程, 根据下图找到 Device Orientation 这一项 勾选需要支持的布局方向
    /// 放到main中会报错，没时间找原因
    /// https://www.codercto.com/a/60738.html
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    /// 后台监听初始化
    Log.log("app manager. init ");
    SP.init().then((sp) {
      _getConfigFromSP();
      DeviceInfo.init();
      UserId.init();
      UserCentre.getInfo();
      SettingCentre.init();
      BackgroundListen().init();
      if (UserCentre.isLogin()) {
        LocalStore.init();
        _configToSP();
      }
    });
  }

  static Future<bool> _configToSP() async {
    ApiResult result = await API.getConfig();
    if (result.isSuccess()) {
      CommonConfigResult? commonConfigResult = result.getData();
      if (commonConfigResult != null) {
        customMenuInfo = commonConfigResult.customMenuInfo;
        if (customMenuInfo?.title == null ||
            customMenuInfo?.url == null ||
            customMenuInfo?.icon == null) customMenuInfo = null;
        Log.yellow("DEBUG=> customMenuInfo $customMenuInfo");
      }
      return result.isSuccess();
    } else {
      return false;
    }
  }

  _getConfigFromSP() async {
    String? configFormSP = SP.getString(SPKey.CONFIG);
    if (configFormSP != null) {
      CommonConfigResult? commonConfigResult =
          CommonConfigResult.fromJson(jsonDecode(SP.getString(SPKey.CONFIG)));
      customMenuInfo = commonConfigResult.customMenuInfo;
      socketServers = commonConfigResult.socketServers;
      Log.yellow("DEBUG=> customMenuInfo $customMenuInfo || $socketServers");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
