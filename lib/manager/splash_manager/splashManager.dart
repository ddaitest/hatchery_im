import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/manager/userCentre.dart';
import 'package:hatchery_im/routers.dart';
import 'package:fluttertoast/fluttertoast.dart';

// import 'package:hatchery_im/api/entity.dart';
import 'dart:collection';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/services.dart';
import 'package:hatchery_im/config.dart';

// import 'package:hatchery_im/common/backgroundListenModel.dart';
import 'package:hatchery_im/common/tools.dart';
import '../../config.dart';

class SplashManager extends ChangeNotifier {
  // String _token = '';

  /// 初始化
  // init() {
  // }

  goto() {
    Future.delayed(
        Duration.zero,
        () => Routers.navigateAndRemoveUntil(
            !UserCentre.isLogin() ? '/login' : '/'));
  }

  // void _checkToken() {
  //   _token = UserCentre.getToken();
  // }
}
