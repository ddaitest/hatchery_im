import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/manager/userCentre.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/AppContext.dart';

class FriendApplyManager extends ChangeNotifier {
  final TextEditingController _applyTextEditingController =
      TextEditingController();
  final TextEditingController _remarkEditingController =
      TextEditingController();
  TextEditingController get applyTextEditingController =>
      _applyTextEditingController;
  TextEditingController get remarkEditingController => _remarkEditingController;

  init() {
    _getStoredForMyProfileData();
  }

  Future _getStoredForMyProfileData() async {
    MyProfile? _myProfile = UserCentre.getInfo();
    if (_myProfile != null) {
      print("_myProfileData ${_myProfile.nickName}");
      _applyTextEditingController.text = '我是 ${_myProfile.nickName}';
    } else {
      showToast('请重新登录');
      UserCentre.logout();
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
    _applyTextEditingController.dispose();
    _remarkEditingController.dispose();
    super.dispose();
  }
}
