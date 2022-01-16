import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/log.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/config.dart';
// import 'package:hatchery_im/common/backgroundListenModel.dart';

class SelectContactsModelManager extends ChangeNotifier {
  late TextEditingController searchController;
  //联系人列表 数据
  List<Friends>? friendsList;
  // 群组成员数据
  List<GroupMembers>? groupMembersList;
  // checkBox选择的联系人
  List<Friends> selectFriendsList = [];
  // checkBox选择的群成员
  List<GroupMembers> selectGroupMembersList = [];
  // 搜索用
  List<Friends> backupFriendsList = [];
  List<GroupMembers> backupGroupMembersList = [];
  List<Widget> selectList = [];

  /// 初始化
  init(SelectContactsType selectContactsType) {
    searchController = TextEditingController();
    if (selectContactsType == SelectContactsType.CreateGroup ||
        selectContactsType == SelectContactsType.AddGroupMember ||
        selectContactsType == SelectContactsType.Share) {
      _queryFriendsRes();
      _searchFriendsInputListener();
    } else if (selectContactsType == SelectContactsType.DeleteGroupMember) {
      _searchGroupMembersInputListener();
    }
  }

  void _searchFriendsInputListener() {
    searchController.addListener(() {
      String _inputText = searchController.text;
      friendsList = List.from(backupFriendsList);
      if (_inputText.isNotEmpty) {
        print('DEBUG=> _inputText $_inputText');
        friendsList!.removeWhere((element) {
          if (element.remarks == null) {
            if (element.nickName.contains(_inputText)) {
              return false;
            } else {
              return true;
            }
          } else {
            if (element.nickName.contains(_inputText) ||
                element.remarks!.contains(_inputText)) {
              return false;
            } else {
              return true;
            }
          }
        });
      } else {
        friendsList = List.from(backupFriendsList);
        print("DEBUG=> else $backupFriendsList");
      }
      print("DEBUG=> friendsList $friendsList");
      notifyListeners();
    });
  }

  void _searchGroupMembersInputListener() {
    searchController.addListener(() {
      String _inputText = searchController.text;
      groupMembersList = List.from(backupGroupMembersList);
      if (_inputText.isNotEmpty) {
        print('DEBUG=> backupGroupMembersList _inputText $_inputText');
        groupMembersList!.removeWhere((element) {
          if (element.nickName!.contains(_inputText)) {
            return false;
          } else {
            return true;
          }
        });
      } else {
        groupMembersList = List.from(backupGroupMembersList);
        print("DEBUG=> backupGroupMembersList else $backupGroupMembersList");
      }
      print("DEBUG=> groupMembersList $groupMembersList");
      notifyListeners();
    });
  }

  void _queryFriendsRes({
    int size = 999,
    int page = 0,
  }) async {
    API.getFriendsListData(size, page).then((value) {
      if (value.isSuccess()) {
        friendsList = value.getDataList((m) => Friends.fromJson(m), type: 1);
        backupFriendsList = List.from(friendsList!);
        print('DEBUG=>  _queryFriendsRes ${friendsList![0].nickName}');
        notifyListeners();
      }
    });
  }

  void copyGroupMembersToList(List<GroupMembers> groupMembers) {
    groupMembersList = groupMembers;
    backupGroupMembersList = groupMembers;
  }

  Future<bool> submit(
      {SelectContactsType? selectContactsType,
      String? groupID,
      String? groupName,
      String? groupDescription,
      String? groupIcon,
      String? notes,
      List<dynamic>? members,
      List<Map<String, String>>? deleteMembersInfo,
      List<String>? inviteJoinMembersInfo}) async {
    ApiResult apiResult;
    String successToastText = '';
    String failToastText = '';
    if (selectContactsType == SelectContactsType.CreateGroup) {
      apiResult = await API.createNewGroup(
          groupName!, groupDescription!, groupIcon!, notes!, members!);
      successToastText = '创建群组成功';
      failToastText = '创建群组失败';
    } else if (selectContactsType == SelectContactsType.AddGroupMember) {
      apiResult = await API.inviteJoinGroup(groupID!, inviteJoinMembersInfo!);
      successToastText = '已发送入群申请';
      failToastText = '入群申请发送失败';
    } else {
      apiResult = await API.deleteGroupMembers(groupID!, deleteMembersInfo!);
      successToastText = '已移出群组';
      failToastText = '移出群组失败';
    }
    if (apiResult.isSuccess()) {
      print("DEBUG=> result.getData() ${apiResult.getData()}");
      showToast('$successToastText');
      Navigator.of(App.navState.currentContext!).pop(true);
    } else {
      showToast('$failToastText');
    }
    return apiResult.isSuccess();
  }

  void addSelectedFriendsIntoList(Friends friends) {
    selectFriendsList.add(friends);
    notifyListeners();
  }

  void addSelectedGroupMembersIntoList(GroupMembers groupMembers) {
    selectGroupMembersList.add(groupMembers);
    notifyListeners();
  }

  void removeSelectedFriendsIntoList(Friends friends) {
    selectFriendsList.remove(friends);
    notifyListeners();
  }

  void removeSelectedGroupMembersIntoList(GroupMembers groupMembers) {
    selectGroupMembersList.remove(groupMembers);
    notifyListeners();
  }

  static initShareMessageContent(
      Map<String, dynamic> messageContent, String contentType) {
    var finalContent;
    switch (contentType) {
      case "TEXT":
        finalContent = messageContent["text"];
        break;
      case "IMAGE":
        finalContent = messageContent;
        break;
      case "VIDEO":
        finalContent = messageContent;
        break;
      case "VOICE":
        finalContent = messageContent['voice_url'];
        break;
      case "URL":
        finalContent = messageContent['text'];
        break;
      case "GEO":
        finalContent = messageContent;
        break;
      case "FILE":
        finalContent = messageContent;
        break;
      case "CARD":
        finalContent = messageContent;
        break;
      default:
        finalContent = messageContent;
        break;
    }
    Log.green("initShareMessageContent $finalContent");
    return finalContent;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
