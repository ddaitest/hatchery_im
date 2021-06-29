import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/routers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/busniess/main_tab.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/services.dart';
import 'package:hatchery_im/config.dart';
// import 'package:hatchery_im/common/backgroundListenModel.dart';
import '../config.dart';

class SelectContactsModelManager extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  //联系人列表 数据
  List<Friends> friendsList = [];
  // checkBox选择的联系人
  List<Friends> selectFriendsList = [];
  static List<Friends> backFriendsList = const [];

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
      print("DEBUG=> backFriendsList$backFriendsList");
      String _inputText = searchController.text;
      friendsList = List.from(backFriendsList);
      if (_inputText.isNotEmpty) {
        friendsList
            .removeWhere((element) => !element.nickName.contains(_inputText));
      } else {
        friendsList = List.from(backFriendsList);
        print("DEBUG=> else $backFriendsList");
      }

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
        backFriendsList = List.from(friendsList);
        // print('DEBUG=>  _queryFriendsRes ${friendsList[0].nickName}');
        notifyListeners();
      }
    });
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
    selectFriendsList.clear();
    searchController.dispose();
    super.dispose();
  }
}
