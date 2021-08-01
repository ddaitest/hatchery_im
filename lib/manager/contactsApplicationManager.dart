import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/config.dart';
// import 'package:hatchery_im/common/backgroundListenModel.dart';
import 'package:hatchery_im/common/tools.dart';
import '../config.dart';

class ContactsApplicationManager extends ChangeNotifier {
  List<SlideActionInfo> slideAction = [];

  /// 初始化
  init() {}

  // querySearchNewContactsData() async {
  //   API.searchNewContacts(searchController!.text).then((value) {
  //     if (value.isSuccess()) {
  //       searchNewContactsList =
  //           value.getDataList((m) => SearchNewContactsInfo.fromJson(m));
  //       print('DEBUG=>  querySearchNewContactsData ${searchNewContactsList}');
  //       notifyListeners();
  //     }
  //   });
  // }

  Future<Function?> replyNewContactsResTap(String usersID, int status,
      {String notes = ''}) async {
    API.replyNewContactsRes(usersID, status, notes: notes).then((value) {
      if (value.isSuccess()) {
        // friendsList = value.getDataList((m) => Friends.fromJson(m), type: 1);
        // print('DEBUG=>  _queryFriendsRes ${friendsList}');
        notifyListeners();
      } else {
        showToast('${value.info}');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
