import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/config.dart';
// import 'package:hatchery_im/common/backgroundListenModel.dart';
import 'package:hatchery_im/common/tools.dart';
import '../config.dart';

class ContactsApplyManager extends ChangeNotifier {
  List<SlideActionInfo> slideAction = [];
  //发送的好友申请数据
  List<FriendsApplicationInfo> sendContactsApplyList = [];

  /// 初始化
  ContactsApplyManager() {
    print("DEBUG=> ContactsApplyManager ContactsApplyManager");
    _sendNewFriendsApplicationRes();
  }

  _sendNewFriendsApplicationRes({
    int size = 999,
    int current = 0,
  }) async {
    API.getSendNewFriendsApplicationListData(size, current).then((value) {
      if (value.isSuccess()) {
        print(
            "DEBUG=> _sendNewFriendsApplicationRes _sendNewFriendsApplicationRes");
        sendContactsApplyList = value
            .getDataList((m) => FriendsApplicationInfo.fromJson(m), type: 1);
        notifyListeners();
      }
    });
  }

  Future<Function?> replyNewContactsResTap(String usersID, int status,
      {String notes = ''}) async {
    API.replyNewContactsRes(usersID, status, notes: notes).then((value) {
      if (value.isSuccess()) {
        // friendsList = value.getDataList((m) => Friends.fromJson(m), type: 1);
        // print('DEBUG=>  _queryFriendsRes ${friendsList}');
        notifyListeners();
      } else {
        showToast('${value.info}');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
