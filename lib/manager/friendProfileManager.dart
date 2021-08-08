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

class FriendProfileManager extends ChangeNotifier {
  UsersInfo? usersInfo;
  Map<String, dynamic>? usersInfoMap;
  //拉黑列表
  List<BlockList>? blockContactsList;
  bool isBlock = false;

  /// 初始化
  init(String friendId) {
    _initMethod(friendId);
  }

  void _initMethod(String friendId) {
    queryBlockListRes().then((value) {
      if (value != null) {
        print("111111111111111111111");
        value ??
            [].forEach((element) {
              print("2222222222222222222");
              if (friendId == element.userID) {
                print("3333333333333333333");
                isBlock = true;
              }
            });
        print("##################");
        getFriendProfileData(friendId);
      } else {
        getFriendProfileData(friendId);
      }
    });
  }

  void refreshData(String friendId) {
    _initMethod(friendId);
  }

  void setBlock(bool value, String friendId) {
    if (value) {
      blockFriend(friendId);
    } else {
      delBlockFriend(friendId);
    }
    isBlock = value;
  }

  Future<dynamic> getFriendProfileData(String friendId) async {
    ApiResult result = await API.getUsersInfo(friendId);
    if (result.isSuccess()) {
      usersInfo = UsersInfo.fromJson(result.getData());
      usersInfoMap = result.getData();
      print(
          "DEBUG=> getFriendProfileData result.getData() ${usersInfo!.nickName}");
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

  Future<dynamic> blockFriend(String friendId) async {
    List<String> friendList = [];
    friendList.add(friendId);
    ApiResult result = await API.blockFriend(friendList);
    if (result.isSuccess()) {
      showToast('好友已拉黑');
      notifyListeners();
    } else {
      showToast('${result.info}');
    }
  }

  Future<dynamic> delBlockFriend(String userID) async {
    List<String> blackUserIds = [];
    blackUserIds.add(userID);
    ApiResult result = await API.delBlockFriend(blackUserIds);
    if (result.isSuccess()) {
      showToast('已移除黑名单');
      notifyListeners();
    } else {
      showToast('${result.info}');
    }
  }

  Future<dynamic> queryBlockListRes({
    int size = 999,
    int current = 0,
  }) async {
    API.getBlockList(size, current).then((value) {
      if (value.isSuccess()) {
        blockContactsList =
            value.getDataList((m) => BlockList.fromJson(m), type: 1);
        return blockContactsList;
      } else {
        return false;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
