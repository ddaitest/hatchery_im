import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:hatchery_im/api/API.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/config.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/common/utils.dart';

class FriendProfileManager extends ChangeNotifier {
  Friends? friendInfo;

  /// 初始化
  init(String friendId) {
    getFriendProfileData(friendId);
  }

  void refreshData() {}

  Future<dynamic> getFriendProfileData(String friendId) async {
    ApiResult result = await API.getFriendInfo(friendId);
    if (result.isSuccess()) {
      friendInfo = Friends.fromJson(result.getData());
      print(
          "DEBUG=> getFriendProfileData result.getData() ${friendInfo!.nickName}");
      notifyListeners();
    } else {
      showToast('${result.info}');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
