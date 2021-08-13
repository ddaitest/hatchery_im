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
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/common/utils.dart';

class GroupProfileManager extends ChangeNotifier {
  GroupInfo? groupInfo;
  GroupMembers? groupMembers;

  /// 初始化
  init(String groupId) {
    getGroupProfileData(groupId);
  }

  void refreshData(String friendId) {}

  Future<dynamic> getGroupProfileData(String groupId) async {
    ApiResult result = await API.getGroupInfo(groupId);
    if (result.isSuccess()) {
      groupInfo = Groups.fromJson(result.getData()).group;
      print(
          "DEBUG=> getGroupProfileData result.getData() ${groupInfo!.groupName}");
      notifyListeners();
    } else {
      showToast('${result.info}');
    }
  }

  Future<dynamic> setFriendRemark(String friendId, String remarkText) async {
    ApiResult result = await API.setFriendRemarkData(friendId, remarkText);
    if (result.isSuccess()) {
      showToast('备注修改成功');
      Future.delayed(Duration(milliseconds: 200), () {
        Navigator.of(App.navState.currentContext!).pop(true);
      });
    } else {
      showToast('${result.info}');
    }
  }

  Future<dynamic> deleteFriend(String friendId) async {
    List<String> friendList = [];
    friendList.add(friendId);
    ApiResult result = await API.deleteFriend(friendList);
    if (result.isSuccess()) {
      showToast('好友已删除');
      Future.delayed(Duration(milliseconds: 200), () {
        Navigator.of(App.navState.currentContext!).pop(false);
        Navigator.of(App.navState.currentContext!).pop(true);
      });
    } else {
      showToast('${result.info}');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
