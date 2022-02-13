import 'dart:convert';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/store/LocalStore.dart';
import '../config.dart';
import '../routers.dart';
import 'messageCentre.dart';

class SettingCentre {
  static SettingConfig? settingConfigInfo;

  static init() {
    String? settingConfigInfoSP = SP.getString(SPKey.SETTING_CONFIG);
    if (settingConfigInfoSP != null) {
      settingConfigInfo =
          SettingConfig.fromJson(jsonDecode(settingConfigInfoSP));
    } else {
      Map<String, dynamic> baseInfo = {"mute": 0, "shock": 0, "notice": 0};
      SP.set(SPKey.SETTING_CONFIG, jsonEncode(baseInfo));
      settingConfigInfo = SettingConfig.fromJson(baseInfo);
    }
  }

  static void setConfig({String? infoKey, int? infoValue}) {
    if (settingConfigInfo != null) {
      Map<String, dynamic> temp = settingConfigInfo!.toJson();
      temp[infoKey!] = infoValue;
      SP.set(SPKey.SETTING_CONFIG, jsonEncode(temp));
      settingConfigInfo = SettingConfig.fromJson(temp);
    } else {
      Map<String, dynamic> baseInfo = {"mute": 0, "shock": 0, "notice": 0};
      SP.set(SPKey.SETTING_CONFIG, jsonEncode(baseInfo));
      settingConfigInfo = SettingConfig.fromJson(baseInfo);
    }
  }
}
