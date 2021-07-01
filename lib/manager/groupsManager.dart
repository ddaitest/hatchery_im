import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/entity.dart';

// import 'package:hatchery_im/common/backgroundListenModel.dart';

class GroupsManager extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  //群列表 数据
  List<Groups> groupsList = [];
  //backup群列表数据，用于搜索结果展示
  List<Groups> backupGroupsList = [];

  /// 初始化
  init() {
    _queryGroupsRes();
    _searchInputListener();
  }

  _queryGroupsRes({
    int size = 999,
    int current = 0,
  }) async {
    API.getGroupListData(size, current).then((value) {
      if (value.isSuccess()) {
        groupsList = value.getDataList((m) => Groups.fromJson(m), type: 1);
        backupGroupsList = List.from(groupsList);
        notifyListeners();
      }
    });
  }

  void refreshData() {
    _queryGroupsRes();
  }

  void _searchInputListener() {
    searchController.addListener(() {
      String _inputText = searchController.text;
      print("DEBUG=> _inputText $_inputText");
      groupsList = List.from(backupGroupsList);
      if (_inputText.isNotEmpty) {
        groupsList.removeWhere(
            (element) => !element.group.groupName!.contains(_inputText));
      } else {
        groupsList = List.from(backupGroupsList);
        print("DEBUG=> else $backupGroupsList");
      }

      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
