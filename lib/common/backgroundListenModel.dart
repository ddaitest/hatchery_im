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
  Timer? _timer;
  void init() {
    WidgetsBinding.instance?.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _timer?.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        Log.red("inactive #################");
        break;
      case AppLifecycleState.resumed: // 应用程序可见，前台
        _timer?.cancel();
        Log.red("resumed #################");
        checkEngineAlive();
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        Log.red("paused #################");
        _timer = Timer.periodic(Duration(seconds: 5), (timer) {
          checkEngineAlive();
        });
        break;
      case AppLifecycleState.detached:
        Log.red("detached #################");
        break;
    }
  }

  /// 检查Engine是否存活
  static checkEngineAlive() {
    if (UserCentre.isLogin()) {
      if (MessageCentre.engine != null) {
        Log.log(
            "MessageCentre.engine!.connectStatus() ${MessageCentre.engine!.connectStatus()}");
        if (!MessageCentre.engine!.connectStatus()) MessageCentre.init();
      } else {
        Log.log("MessageCentre.engine = null");
        MessageCentre.init();
      }
    }
  }
}
