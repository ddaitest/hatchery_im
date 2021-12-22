import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:hatchery_im/api/ApiResult.dart';

import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/backgroundListenModel.dart';
import 'package:hatchery_im/common/log.dart';
import 'dart:collection';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/services.dart';
import 'package:hatchery_im/business/chat_home/chat_page.dart';
import 'package:hatchery_im/business/contacts/contacts_page.dart';
import 'package:hatchery_im/business/group_page/groupList.dart';
import 'package:hatchery_im/business/profile_page/my_profile.dart';

// import 'package:hatchery_im/common/backgroundListenModel.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/manager/userCentre.dart';
import 'package:hatchery_im/store/LocalStore.dart';
import '../../config.dart';
import '../messageCentre.dart';

class AppManager extends ChangeNotifier {
  CustomMenuInfo? customMenuInfo;

  /// 初始化
  init() {
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
      BackgroundListen().init();
      if (UserCentre.isLogin()) {
        LocalStore.init();
        _configToSP();
      }
    });
  }

  Future<bool> _configToSP() async {
    ApiResult result = await API.getConfig();
    if (result.isSuccess()) {
      SP.set(SPKey.config, jsonEncode(result.getData()));
      return result.isSuccess();
    } else {
      return false;
    }
  }

  _getConfigFromSP() async {
    String? _configData = SP.getString(SPKey.config);
    if (_configData != null) {
      customMenuInfo =
          CustomMenuInfo.fromJson(jsonDecode(_configData)['customMenu']);
      Log.yellow("DEBUG=> customMenuInfo $customMenuInfo");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
