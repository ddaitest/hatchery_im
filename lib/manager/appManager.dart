import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:hatchery_im/api/ApiResult.dart';
// import 'package:hatchery_im/common/backgroundListenModel.dart';
import 'package:hatchery_im/business/chat_home/chat_page.dart';
import 'package:hatchery_im/business/contacts/contacts_page.dart';
import 'package:hatchery_im/business/group_page/group.dart';
import 'package:hatchery_im/business/profile_page/my_profile.dart';
import 'package:hatchery_im/common/tools.dart';
import '../config.dart';
import 'messageCentre.dart';

class AppManager extends ChangeNotifier {
  CustomMenuInfo? customMenuInfo;
  var bottomTabs = mainTabs;
  List<Widget> bottomBarIcon = [];
  List<Widget> tabBodies = [
    ChatPage(),
    ContactsPage(),
    GroupPage(),
    MyProfilePage()
  ];

  PageController pageController = PageController();
  int tabIndex = 0;
  String title = '消息列表';

  /// 初始化
  init() {
    /// 后台监听初始化
    // BackgroundListen().init();
    SP.init().then((sp) {
      _getConfigFromSP();
      DeviceInfo.init();
      UserId.init();
      MessageCentre.init();
    });
  }

  _getConfigFromSP() async {
    String? _configData = SP.getString(SPKey.config);
    if (_configData != null) {
      customMenuInfo =
          CustomMenuInfo.fromJson(jsonDecode(_configData)['customMenu']);
      print("DEBUG=> customMenuInfo $customMenuInfo");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
