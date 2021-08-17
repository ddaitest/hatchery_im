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

  void refreshData(String friendId) {}

  Future<dynamic> getGroupProfileData(String groupId) async {
    ApiResult result = await API.getGroupInfo(groupId);
    if (result.isSuccess()) {
      groupInfo = Groups.fromJson(result.getData()).group;
      // groupMembersList = Groups.fromJson(result.getData()).top3Members;
      print("DEBUG=> getGroupProfileData groupInfo ${groupInfo!.groupName}");
      // print(
      //     "DEBUG=> getGroupProfileData groupMembersList ${groupMembersList![0].nickName}");
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

  void _checkManager() {
    _getStoredForMyProfileData().then((value) {
      groupMembersList!.forEach((element) {
        if (element.userID == value!.userID && element.groupRole != 0)
          isManager = true;
        nickNameForGroup = element.groupNickName ?? value.nickName;
      });
    });
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

  @override
  void dispose() {
    isManager = false;
    super.dispose();
  }
}
