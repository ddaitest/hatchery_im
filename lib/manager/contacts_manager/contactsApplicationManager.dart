import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/common/utils.dart';

class ContactsApplyManager extends ChangeNotifier {
  //发送的好友申请数据
  List<FriendsApplicationInfo> _sendContactsApplyList = [];
  //接收的好友申请数据
  List<FriendsApplicationInfo>? _receiveContactsApplyList;
  List<FriendsApplicationInfo> get sendContactsApplyList =>
      _sendContactsApplyList;
  List<FriendsApplicationInfo>? get receiveContactsApplyList =>
      _receiveContactsApplyList;

  /// 初始化
  init() {
    _sendNewFriendsApplicationRes();
    _receiveNewFriendsApplicationRes();
  }

  _sendNewFriendsApplicationRes({
    int size = 999,
    int current = 0,
  }) async {
    API.getSendNewFriendsApplicationListData(size, current).then((value) {
      if (value.isSuccess()) {
        print(
            "DEBUG=> _sendNewFriendsApplicationRes _sendNewFriendsApplicationRes");
        _sendContactsApplyList = value
            .getDataList((m) => FriendsApplicationInfo.fromJson(m), type: 1);
        notifyListeners();
      }
    });
  }

  _receiveNewFriendsApplicationRes({
    int size = 999,
    int current = 0,
  }) async {
    API.getReceiveNewFriendsApplicationListData(size, current).then((value) {
      if (value.isSuccess()) {
        _receiveContactsApplyList = value
            .getDataList((m) => FriendsApplicationInfo.fromJson(m), type: 1);
        notifyListeners();
      }
    });
  }

  Future<Function?> replyNewContactsResTap(String usersID, int status) async {
    API.replyNewContactsRes(usersID, status).then((value) {
      if (value.isSuccess()) {
        // friendsList = value.getDataList((m) => Friends.fromJson(m), type: 1);
        // print('DEBUG=>  _queryFriendsRes ${friendsList}');
        showToast(status == 1 ? '已同意' : '已拒绝');
        Future.delayed(Duration(milliseconds: 300), () {
          _receiveNewFriendsApplicationRes();
        });
      } else {
        showToast('${value.info}');
      }
    });
    return null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
