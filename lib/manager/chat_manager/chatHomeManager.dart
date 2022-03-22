import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/log.dart';
import 'package:hatchery_im/manager/messageCentre.dart';
import 'package:hatchery_im/store/LocalStore.dart';

class ChatHomeManager extends ChangeNotifier {
  int _totalUnReadMessageCount = 0;
  int get totalUnReadMessageCount => _totalUnReadMessageCount;

  /// 初始化
  void init() {
    /// 等待hive和messageBox & sessionBox初始化完成后再加载 MessageCentre.init()
    _waitBoxLoad().whenComplete(() {
      MessageCentre.init();
      LocalStore.listenSessions().addListener(() {
        Log.yellow("ChatHomeManager listenSessions");
        _getUnReadTotalCount();
      });
    });
  }

  /// 等待hive和messageBox & sessionBox初始化完成
  static Future<void> _waitBoxLoad() async {
    await Future.doWhile(
        () => LocalStore.messageBox == null && LocalStore.sessionBox == null);
  }

  /// 获取总的未读消息数。来源：其他session的未读数的总和，大于等于0条时才会刷新UI
  int _getUnReadTotalCount() {
    int count = 0;
    LocalStore.sessionBox?.values.forEach((Session session) {
      if (session.unReadCount != null) {
        count = count + session.unReadCount!;
      }
    });
    _totalUnReadMessageCount = count;
    if (count >= 0) notifyListeners();
    return _totalUnReadMessageCount;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
