import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hatchery_im/manager/messageCentre.dart';
import 'package:hatchery_im/common/log.dart';
import 'package:hatchery_im/manager/userCentre.dart';

class BackLock {
  ///当特殊工作时候，进行标记。如选照片。
  static bool working = false;
}

class BackgroundListen with WidgetsBindingObserver {
  void init() {
    WidgetsBinding.instance?.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        Log.red("inactive #################");
        break;
      case AppLifecycleState.resumed: // 应用程序可见，前台
        Log.red("resumed #################");
        if (UserCentre.isLogin()) {
          MessageCentre.init();
        }
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        Log.red("paused #################");
        break;
      case AppLifecycleState.detached:
        Log.red("detached #################");
        break;
    }
  }
}
