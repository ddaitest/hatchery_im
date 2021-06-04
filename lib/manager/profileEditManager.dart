import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/config.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/common/utils.dart';

class ProfileEditManager extends ChangeNotifier {
  MyProfile? myProfileData;
  final GlobalKey<FormState> profileEditInputKey = GlobalKey<FormState>();
  TextEditingController nickNameController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  /// 初始化
  ProfileEditManager() {
    _getStoredForMyProfileData();
  }

  _getStoredForMyProfileData() async {
    String? stored = SP.getString(SPKey.userInfo);
    if (stored != null) {
      print("_myProfileData ${stored}");
      try {
        var userInfo = MyProfile.fromJson(jsonDecode(stored)['info']);
        myProfileData = userInfo;
        print("_myProfileData ${myProfileData!.icon}");
        notifyListeners();
      } catch (e) {}
    } else {
      showToast('请重新登录');
      SP.delete(SPKey.userInfo);
      Future.delayed(Duration(seconds: 1), () => Routers.navigateReplace('/'));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
