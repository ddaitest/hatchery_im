import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/log.dart';
import 'package:hatchery_im/manager/messageCentre.dart';
import 'package:hatchery_im/store/LocalStore.dart';

class ChatHomeManager extends ChangeNotifier {
  int totalUnReadMessageCount = 0;

  /// 初始化
  init() {
    /// 等待hive和messageBox & sessionBox初始化完成后再加载 MessageCentre.init()
    waitBoxLoad().whenComplete(() {
      MessageCentre.init();
      LocalStore.listenSessions().addListener(() {
        Log.yellow("ChatHomeManager listenSessions");
        getUnReadTotalCount();
      });
    });
  }

  /// 等待hive和messageBox & sessionBox初始化完成
  Future<void> waitBoxLoad() async {
    await Future.doWhile(
        () => LocalStore.messageBox == null && LocalStore.sessionBox == null);
  }

  /// 获取总的未读消息数。来源：其他session的未读数的总和，大于等于0条时才会刷新UI
  int getUnReadTotalCount() {
    int count = 0;
    LocalStore.sessionBox?.values.forEach((Session session) {
      if (session.unReadCount != null) {
        count = count + session.unReadCount!;
      }
    });
    totalUnReadMessageCount = count;
    if (count >= 0) notifyListeners();
    return totalUnReadMessageCount;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
