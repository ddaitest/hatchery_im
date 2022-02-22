import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/common/log.dart';
import 'package:hatchery_im/common/utils.dart';

import '../../settingCentre.dart';

class SettingManager extends ChangeNotifier {
  /// 是否静音，0=打开声音，1=静音
  int? muteStatus;

  ///是否震动，0=打开震动，1=关闭震动
  int? shockStatus;

  ///是否通知，0=打开通知，1=关闭通知
  int? noticeStatus;

  /// 初始化
  init() {
    muteStatus = SettingCentre.settingConfigInfo?.mute ?? 0;
    shockStatus = SettingCentre.settingConfigInfo?.shock ?? 0;
    noticeStatus = SettingCentre.settingConfigInfo?.notice ?? 0;
    Log.green("settingConfigInfo mute $muteStatus");
    Log.green("settingConfigInfo shock $shockStatus");
    Log.green("settingConfigInfo notification $noticeStatus");
  }

  void switchSet(infoKey, value) {
    SettingCentre.setConfig(infoKey: infoKey, infoValue: value ? 0 : 1);
    muteStatus = SettingCentre.settingConfigInfo?.mute ?? 0;
    shockStatus = SettingCentre.settingConfigInfo?.shock ?? 0;
    noticeStatus = SettingCentre.settingConfigInfo?.notice ?? 0;
    notifyListeners();
    showToast("设置成功");
  }

  @override
  void dispose() {
    super.dispose();
  }
}
