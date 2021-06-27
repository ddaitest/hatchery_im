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
import 'dart:collection';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/services.dart';
import 'package:hatchery_im/config.dart';
// import 'package:hatchery_im/common/backgroundListenModel.dart';
import 'package:hatchery_im/common/tools.dart';
import '../config.dart';

class GroupsManager extends ChangeNotifier {
  //联系人列表 数据
  List<Groups> groupsList = [];

  List<FriendsApplicationInfo> groupApplicationList = [];

  /// 初始化
  init() {
    _queryGroupsRes();
  }

  _queryGroupsRes({
    int size = 999,
    int current = 0,
  }) async {
    API.getGroupListData(size, current).then((value) {
      if (value.isSuccess()) {
        groupsList = value.getDataList((m) => Groups.fromJson(m), type: 1);
        print('DEBUG=>  _queryGroupsRes ${groupsList}');
        notifyListeners();
      }
    });
  }

  void refreshData() {
    _queryGroupsRes();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
