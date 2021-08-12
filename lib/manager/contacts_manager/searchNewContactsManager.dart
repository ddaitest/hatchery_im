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
import '../../config.dart';

class SearchNewContactsManager extends ChangeNotifier {
  late TextEditingController? searchController;
  bool showSearchBtn = false;
  List<SearchNewContactsInfo> searchNewContactsList = [];

  /// 初始化
  init() {
    searchController = TextEditingController();
    checkSearchBtnListener();
  }

  querySearchNewContactsData() async {
    searchNewContactsList.clear();
    if (searchController!.text != '') {
      API.searchNewContacts(searchController!.text).then((value) {
        if (value.isSuccess()) {
          searchNewContactsList =
              value.getDataList((m) => SearchNewContactsInfo.fromJson(m));
          print('DEBUG=>  querySearchNewContactsData ${searchNewContactsList}');
          notifyListeners();
        }
      });
    }
  }

  checkSearchBtnListener() {
    searchController!.addListener(() {
      if (searchController!.text != '') {
        showSearchBtn = true;
      } else {
        showSearchBtn = false;
      }

      notifyListeners();
    });
  }

  @override
  void dispose() {
    searchController!.dispose();
    super.dispose();
  }
}
