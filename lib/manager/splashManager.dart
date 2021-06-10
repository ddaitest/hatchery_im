import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/routers.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:hatchery_im/api/entity.dart';
import 'dart:collection';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/services.dart';
import 'package:hatchery_im/config.dart';
// import 'package:hatchery_im/common/backgroundListenModel.dart';
import 'package:hatchery_im/common/tools.dart';
import '../config.dart';

class SplashManager extends ChangeNotifier {
  String? _userInfoData;
  String _token = '';

  /// 初始化
  init() {}

  goto() {
    _checkToken();

    Future.delayed(Duration.zero,
        () => Routers.navigateAndRemoveUntil(_token == '' ? '/login' : '/'));
  }

  void _checkToken() {
    _userInfoData = SP.getString(SPKey.userInfo);
    if (_userInfoData != null) {
      _token = jsonDecode(SP.getString(SPKey.userInfo))['token'];
      getConfig();
    }
  }

  Future<bool> getConfig() async {
    ApiResult result = await API.getConfig();
    if (result.isSuccess()) {
      SP.set(SPKey.config, jsonEncode(result.getData()));
    }
    return result.isSuccess();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
