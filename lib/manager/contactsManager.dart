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

import 'app_handler.dart';

class ContactsManager extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  //联系人列表 数据
  List<Friends>? friendsList;
  //未处理的好友申请
  int untreatedReceiveContactsApplyLength = 0;
  List<Friends> backupFriendsList = [];

  final size = 999; //暂时一次取完。

  /// 初始化
  init() {
    _queryFriendsRes();
    _receiveNewFriendsApplicationRes();
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

  ///刷新好友列表.
  /// Step1. 返回本地存储的数据。
  /// Step2. 从Server获取最新数据。
  /// Step3. 刷新本地数据。
  _queryFriendsRes({
    int size = 999,
    int current = 0,
  }) async {
    // Step1. 返回本地存储的数据。
    AppHandler.getFriends().then((value) {
      if (value.length > 0) {
        friendsList = value;
        notifyListeners();
      }
    });
    // Step2. 从Server获取最新数据。
    API.getFriendsListData(size, current).then((value) {
      if (value.isSuccess()) {
        friendsList = value.getDataList((m) => Friends.fromJson(m), type: 1);
        backupFriendsList = List.from(friendsList!);
        // Step3. 刷新本地数据。
        AppHandler.saveFriends(friendsList);
        print('DEBUG=>  _queryFriendsRes ${friendsList}');
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
        value.getDataList(
            (m) => m.forEach((key, value) {
                  if (key == 'status') {
                    if (value == 1) {
                      untreatedReceiveContactsApplyLength =
                          untreatedReceiveContactsApplyLength + 1;
                    }
                  }
                }),
            type: 1);
        notifyListeners();
      }
    });
  }

  void refreshData() {
    searchController.clear();
    untreatedReceiveContactsApplyLength = 0;
    FocusScope.of(App.navState.currentContext!).requestFocus(FocusNode());
    _queryFriendsRes();
    _receiveNewFriendsApplicationRes();
  }

  @override
  void dispose() {
    searchController.dispose();
    untreatedReceiveContactsApplyLength = 0;
    super.dispose();
  }
}
