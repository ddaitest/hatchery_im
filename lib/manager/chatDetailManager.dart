import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:hatchery_im/api/entity.dart';
import 'dart:collection';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/services.dart';
import 'package:hatchery_im/config.dart';
// import 'package:hatchery_im/common/backgroundListenModel.dart';
import 'package:hatchery_im/common/tools.dart';
import '../config.dart';

class ChatDetailManager extends ChangeNotifier {
  MyProfile? myProfileData;
  List<FriendsHistoryMessages> messagesList = [];

  /// 初始化
  init() {
    _getStoredForMyProfileData();
  }

  queryFriendsHistoryMessages(String friendId, int? currentMsgID,
      {int current = 0, int size = 50}) async {
    API
        .messageHistoryWithFriend(
            friendID: friendId,
            size: size,
            current: current,
            currentMsgID: currentMsgID!)
        .then((value) {
      if (value.isSuccess()) {
        messagesList = value
            .getDataList((m) => FriendsHistoryMessages.fromJson(m), type: 0);
        // messagesList = messagesList.reversed.toList();
        messagesList.forEach((element) {
          print('DEBUG=>  queryFriendsHistoryMessages ${element.createTime}');
        });

        notifyListeners();
      }
    });
  }

  _getStoredForMyProfileData() async {
    String? stored = SP.getString(SPKey.userInfo);
    if (stored != null) {
      print("_myProfileData ${stored}");
      try {
        var userInfo = MyProfile.fromJson(jsonDecode(stored)['info']);
        myProfileData = userInfo;
        print("_myProfileData ${myProfileData!.userID}");
      } catch (e) {}
    } else {
      showToast('请重新登录');
      SP.delete(SPKey.userInfo);
      Future.delayed(
          Duration(seconds: 1), () => Routers.navigateAndRemoveUntil('/login'));
    }
  }

  @override
  void dispose() {
    messagesList.clear();
    super.dispose();
  }
}
