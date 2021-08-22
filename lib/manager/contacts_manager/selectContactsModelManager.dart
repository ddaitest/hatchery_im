import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/common/AppContext.dart';
// import 'package:hatchery_im/common/backgroundListenModel.dart';

class SelectContactsModelManager extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  //联系人列表 数据
  List<Friends>? friendsList;
  // checkBox选择的联系人
  List<Friends> selectFriendsList = [];
  List<Friends> backupFriendsList = [];

  /// 初始化
  init() {
    _queryFriendsRes();
    _searchInputListener();
  }

  SelectContactsModelManager() {
    init();
  }

  void _searchInputListener() {
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

  _queryFriendsRes({
    int size = 999,
    int page = 0,
  }) async {
    API.getFriendsListData(size, page).then((value) {
      if (value.isSuccess()) {
        friendsList = value.getDataList((m) => Friends.fromJson(m), type: 1);
        backupFriendsList = List.from(friendsList!);
        // print('DEBUG=>  _queryFriendsRes ${friendsList[0].nickName}');
        notifyListeners();
      }
    });
  }

  Future<bool> submit(
    String groupName,
    String groupDescription,
    String groupIcon,
    String notes,
    List<dynamic> members,
  ) async {
    ApiResult result = await API.createNewGroup(
        groupName, groupDescription, groupIcon, notes, members);
    if (result.isSuccess()) {
      print("DEBUG=> result.getData() ${result.getData()}");
      showToast('创建群组成功');
      Navigator.of(App.navState.currentContext!).pop(true);
    } else {
      showToast('创建群组失败');
    }
    return result.isSuccess();
  }

  void addSelectedFriendsIntoList(Friends friends) {
    selectFriendsList.add(friends);
    notifyListeners();
  }

  void removeSelectedFriendsIntoList(Friends friends) {
    selectFriendsList.remove(friends);
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
