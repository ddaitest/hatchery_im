import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/routers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hatchery_im/api/entity.dart';
import 'dart:collection';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/services.dart';
import 'package:hatchery_im/config.dart';
// import 'package:hatchery_im/common/backgroundListenModel.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ContactsManager extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  //联系人列表 数据
  List<Friends>? friendsList;
  //好友申请 数据
  List<FriendsApplicationInfo> contactsApplicationList = [];
  List<Friends> backupFriendsList = [];

  /// 初始化
  init() {
    _queryFriendsRes();
    _queryNewFriendsApplicationRes();
    _searchInputListener();
  }

  void _searchInputListener() {
    searchController.addListener(() {
      String _inputText = searchController.text;
      friendsList = List.from(backupFriendsList);
      if (_inputText.isNotEmpty) {
        friendsList!
            .removeWhere((element) => !element.nickName.contains(_inputText));
        friendsList!.removeWhere((element) =>
            element.remarks != null && !element.remarks!.contains(_inputText));
      } else {
        friendsList = List.from(backupFriendsList);
      }

      notifyListeners();
    });
  }

  _queryFriendsRes({
    int size = 999,
    int current = 0,
  }) async {
    API.getFriendsListData(size, current).then((value) {
      if (value.isSuccess()) {
        friendsList = value.getDataList((m) => Friends.fromJson(m), type: 1);
        backupFriendsList = List.from(friendsList!);
        notifyListeners();
      }
    });
  }

  _queryNewFriendsApplicationRes({
    int size = 999,
    int current = 0,
  }) async {
    API.getNewFriendsApplicationListData(size, current).then((value) {
      if (value.isSuccess()) {
        contactsApplicationList = value
            .getDataList((m) => FriendsApplicationInfo.fromJson(m), type: 1);
        notifyListeners();
      }
    });
  }

  void refreshData() {
    searchController.clear();
    FocusScope.of(App.navState.currentContext!).requestFocus(FocusNode());
    _queryFriendsRes();
    _queryNewFriendsApplicationRes();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
