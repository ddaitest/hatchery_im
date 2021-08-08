import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// import 'package:hatchery_im/api/entity.dart';
import 'dart:collection';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/services.dart';

// import 'package:hatchery_im/common/backgroundListenModel.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/manager/userCentre.dart';
import '../config.dart';
import 'messageCentre.dart';

class AppManager extends ChangeNotifier {
  // UnmodifiableListView<Contact> get phoneNumbersList =>
  //     UnmodifiableListView(_phoneNumbersList);

  // int get total => _phoneNumbersList.length;

  DateTime now = DateTime.now();

  /// 初始化
  init() {
    /// 后台监听初始化
    // BackgroundListen().init();
    SP.init().then((sp) {
      DeviceInfo.init();
      UserId.init();
      UserCentre.getInfo();
      if (UserCentre.isLogin()) {
        MessageCentre.init();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
