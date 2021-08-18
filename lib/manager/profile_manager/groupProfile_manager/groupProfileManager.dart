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
import 'package:hatchery_im/manager/userCentre.dart';

class GroupProfileManager extends ChangeNotifier {
  GroupInfo? groupInfo;
  List<GroupMembers>? groupMembersList;
  String? nickNameForGroup;
  bool isManager = false;

  /// 初始化
  init(String groupId) {
    getGroupProfileData(groupId);
    getGroupMembersData(groupId);
  }

  void refreshData(String groupId) {
    init(groupId);
  }

  Future<dynamic> getGroupProfileData(String groupId) async {
    ApiResult result = await API.getGroupInfo(groupId);
    if (result.isSuccess()) {
      groupInfo = Groups.fromJson(result.getData()).group;
      print("DEBUG=> getGroupProfileData groupInfo ${groupInfo!.groupName}");
      notifyListeners();
    } else {
      showToast('${result.info}');
    }
  }

  Future<dynamic> getGroupMembersData(String groupId) async {
    ApiResult result = await API.getGroupMembers(groupId);
    if (result.isSuccess()) {
      groupMembersList =
          result.getDataList((m) => GroupMembers.fromJson(m), type: 1);
      print(
          "DEBUG=> getGroupMembersData result.getData() ${groupMembersList![0].nickName}");
      _checkManager();
      notifyListeners();
    } else {
      showToast('${result.info}');
    }
  }

  void _checkManager() async {
    String myUserID = UserCentre.getUserID();
    for (var i = 0; i < groupMembersList!.length; i++) {
      if (groupMembersList![i].userID == myUserID &&
          groupMembersList![i].groupRole != 0) {
        nickNameForGroup =
            groupMembersList![i].groupNickName ?? groupMembersList![i].nickName;
        isManager = true;
        break;
      } else if (groupMembersList![i].userID == myUserID) {
        nickNameForGroup =
            groupMembersList![i].groupNickName ?? groupMembersList![i].nickName;
        break;
      }
    }
  }

  Future<MyProfile?> _getStoredForMyProfileData() async {
    MyProfile? myProfileData = UserCentre.getInfo();
    if (myProfileData != null) {
      print("_myProfileData ${myProfileData.loginName}");
      return myProfileData;
    } else {
      showToast('请重新登录');
      UserCentre.logout();
      Future.delayed(
          Duration(seconds: 1), () => Routers.navigateAndRemoveUntil('/login'));
    }
  }

  Future<dynamic> updateGroupNickNameData(
      String groupId, String groupNickName) async {
    ApiResult result = await API.updateGroupNickName(groupId, groupNickName);
    if (result.isSuccess()) {
      showToast('群昵称修改成功');
      Future.delayed(Duration(milliseconds: 200), () {
        Navigator.of(App.navState.currentContext!).pop(true);
      });
    } else {
      showToast('${result.info}');
    }
  }

  @override
  void dispose() {
    isManager = false;
    super.dispose();
  }
}
