import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
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
import '../../config.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../app_manager/app_handler.dart';

class ChatHomeManager extends ChangeNotifier {
  List<Session> sessions = [];

  /// 初始化
  init() {
    //设置监听
    // MessageCentre().listenSessions((news) {
    //   sessions = news;
    //   print("DEBUG=> ChatHomeManager sessions $sessions");
    //   notifyListeners();
    // });
  }

  // void _readMessages(bool notify) {
  //   var temp;
  //   Log.red(currentFriendId != ""
  //       ? "listenMessage >> friendId =$currentFriendId"
  //       : "listenMessage >> groupId =$currentGroupId");
  //   LocalStore.messageBox!.values.forEach((element) {
  //     temp = LocalStore.messageBox!.values
  //         .where((element) => element.groupID == ""
  //
  //     /// 防止换号后消息对不上
  //         ? (element.receiver == currentFriendId &&
  //         element.sender == myProfileData!.userID) ||
  //         (element.sender == currentFriendId &&
  //             element.receiver == myProfileData!.userID)
  //         : element.groupID == currentGroupId)
  //         .toList();
  //   });
  //   if (temp != null && temp.length != messagesList.length) {
  //     messagesList = temp;
  //     messagesList.sort((a, b) =>
  //         DateTime.fromMillisecondsSinceEpoch(b.createTime)
  //             .compareTo(DateTime.fromMillisecondsSinceEpoch(a.createTime)));
  //     if (notify) {
  //       notifyListeners();
  //     }
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
  }
}
