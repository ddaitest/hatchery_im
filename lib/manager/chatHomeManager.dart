import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/manager/messageCentre.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/config.dart';

// import 'package:hatchery_im/common/backgroundListenModel.dart';
import 'package:hatchery_im/config.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/common/tools.dart';
import '../config.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'app_handler.dart';

class ChatHomeManager extends ChangeNotifier {
  List<SlideActionInfo> slideAction = [
    SlideActionInfo('置顶', Icons.upload_rounded, Flavors.colorInfo.mainColor),
    SlideActionInfo('不提醒', Icons.notifications_off, Flavors.colorInfo.blueGrey),
    SlideActionInfo('删除', Icons.delete, Colors.red),
  ];

  List<Session>? sessions;

  /// 初始化
  init() {
    //设置监听
    MessageCentre().listenSessions((news) {
      sessions = news;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
