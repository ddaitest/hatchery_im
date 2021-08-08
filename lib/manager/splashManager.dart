import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/entity.dart';
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
  String _token = '';

  /// 初始化
  init() async {
    await Future.delayed(Duration(seconds: 1), () {
      _checkToken();
    });
  }

  goto() {
    Future.delayed(Duration.zero,
        () => Routers.navigateAndRemoveUntil(_token == '' ? '/login' : '/'));
  }

  void _checkToken() {
    String? _userInfoData = SP.getString(SPKey.userInfo);
    if (_userInfoData != null) {
      _token = jsonDecode(_userInfoData)['token'];
      _configToSP();
    }
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

  @override
  void dispose() {
    super.dispose();
  }
}
