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

class LoginManager extends ChangeNotifier {
  final GlobalKey<FormState> _loginInputKey = GlobalKey<FormState>();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  GlobalKey<FormState> get loginInputKey => _loginInputKey;
  TextEditingController get accountController => _accountController;
  TextEditingController get codeController => _codeController;

  LoginManager() {}

  Future<bool> submit(String account, String password) async {
    ApiResult result = await API.usersLogin(account, password);
    if (result.isSuccess()) {
      print("DEBUG=> result.getData() ${result.getData()}");
      SP.set(SPKey.userInfo, result.getData());
      Routers.navigateReplace('/');
    }
    return result.isSuccess();
  }

  @override
  void dispose() {
    _accountController.dispose();
    _codeController.dispose();
    super.dispose();
  }
}
