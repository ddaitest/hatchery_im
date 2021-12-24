import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/log.dart';
import 'package:hatchery_im/manager/messageCentre.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/config.dart';

// import 'package:hatchery_im/common/backgroundListenModel.dart';
import 'package:hatchery_im/config.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/store/LocalStore.dart';
import 'package:hive/hive.dart';
import '../../config.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../app_manager/app_handler.dart';
import '../userCentre.dart';

class ChatHomeManager extends ChangeNotifier {
  int totalUnReadMessageCount = 0;

  /// 初始化
  init() {
    waitBoxLoad().whenComplete(() {
      MessageCentre.init();
      LocalStore.listenMessage().addListener(() {
        Log.yellow("ChatHomeManager listenMessage");
        getUnReadTotalCount();
      });
    });
  }

  Future<void> waitBoxLoad() async {
    await Future.doWhile(
        () => LocalStore.messageBox == null && LocalStore.sessionBox == null);
  }

  int getUnReadTotalCount() {
    int count = 0;
    count = LocalStore.getUnReadMessageCount(
        LocalStore.messageBox?.values.toList() ?? []);
    Log.green("getUnReadTotalCount $count");
    totalUnReadMessageCount = count;
    if (count > 0) notifyListeners();
    return totalUnReadMessageCount;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
