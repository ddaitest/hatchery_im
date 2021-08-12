import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/config.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/AppContext.dart';
// import 'package:hatchery_im/common/backgroundListenModel.dart';
import 'package:hatchery_im/common/tools.dart';
import '../../config.dart';

class FriendApplyManager extends ChangeNotifier {
  TextEditingController applyTextEditingController = TextEditingController();
  TextEditingController remarkEditingController = TextEditingController();

  FriendApplyManager() {
    _getStoredForMyProfileData();
  }

  Future _getStoredForMyProfileData() async {
    String? stored = SP.getString(SPKey.userInfo);
    if (stored != null) {
      print("_myProfileData ${stored}");
      try {
        MyProfile userInfo = MyProfile.fromJson(jsonDecode(stored)['info']);
        applyTextEditingController.text = '我是';
      } catch (e) {}
    } else {
      showToast('请重新登录');
      SP.delete(SPKey.userInfo);
      Future.delayed(
          Duration(seconds: 1), () => Routers.navigateAndRemoveUntil('/login'));
    }
  }

  Future<dynamic> submitApply(
      String usersID, String desc, String remarks) async {
    ApiResult result = await API.friendApplyRes(usersID, desc, remarks);
    if (result.isSuccess()) {
      showToast('申请成功');
      Future.delayed(Duration(milliseconds: 200), () {
        Navigator.of(App.navState.currentContext!).pop(true);
      });
      notifyListeners();
    } else {
      showToast('${result.info}');
    }
  }

  @override
  void dispose() {
    applyTextEditingController.dispose();
    remarkEditingController.dispose();
    super.dispose();
  }
}
