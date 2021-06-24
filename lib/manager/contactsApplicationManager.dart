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

class ContactsApplicationManager extends ChangeNotifier {
  List<SlideActionInfo> slideAction = [];

  /// 初始化
  init() {
    _addSlideAction();
  }

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

  void _addSlideAction() {
    slideAction.add(
      SlideActionInfo('拒绝', Icons.no_accounts, Colors.red, onTap: denyBtnTap),
    );
    slideAction.add(
      SlideActionInfo('忽略', Icons.alarm_off, Flavors.colorInfo.mainColor,
          onTap: ignoreBtnTap),
    );
  }

  Function? denyBtnTap() {
    return null;
  }

  Function? ignoreBtnTap() {
    return null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
