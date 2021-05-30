import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:hatchery_im/api/entity.dart';
import 'dart:collection';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/services.dart';
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

  LoginManager() {
    SP.init().then((sp) {
      DeviceInfo.init();
      UserId.init();
    });
  }

  @override
  void dispose() {
    _accountController.dispose();
    _codeController.dispose();
    super.dispose();
  }
}
