import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/common/utils.dart';
// import 'package:hatchery_im/api/entity.dart';
import 'dart:collection';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/services.dart';
import 'package:hatchery_im/config.dart';
// import 'package:hatchery_im/common/backgroundListenModel.dart';
import 'package:hatchery_im/common/tools.dart';
import '../config.dart';

class LoginManager extends ChangeNotifier {
  TextEditingController accountController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController phoneCodeController = TextEditingController();
  bool isOTPLogin = false;

  /// 初始化
  init() {}

  void setOTPLogin() {
    isOTPLogin = !isOTPLogin;
    notifyListeners();
  }

  Future<bool> submit(String account, String password) async {
    ApiResult result = await API.usersLogin(account, password);
    if (result.isSuccess()) {
      print("DEBUG=> result.getData() ${result.getData()}");
      SP.set(SPKey.userInfo, jsonEncode(result.getData()));
      Routers.navigateAndRemoveUntil('/');
    } else {
      showToast('账号或密码错误');
    }
    return result.isSuccess();
  }

  @override
  void dispose() {
    accountController.dispose();
    codeController.dispose();
    super.dispose();
  }
}
