import 'dart:async';
import 'package:hatchery_im/api/API.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/config.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/manager/userCentre.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/common/utils.dart';

class ProfileEditManager extends ChangeNotifier {
  MyProfile? myProfileData;
  String imageUrl = "";
  double uploadProgress = 0.0;

  /// 初始化
  init() {
    _getStoredForMyProfileData();
  }

  _getStoredForMyProfileData() async {
    myProfileData = UserCentre.getInfo();
    if (myProfileData != null) {
      print("_myProfileData ${myProfileData!.loginName}");
      imageUrl = myProfileData!.icon ?? '';
    } else {
      showToast('请重新登录');
      UserCentre.logout();
      Future.delayed(
          Duration(seconds: 1), () => Routers.navigateAndRemoveUntil('/login'));
    }
  }

  Future<bool> uploadImage(String filePath) async {
    ApiResult result = await compressionImage(filePath)
        .then((value) => ApiForFileService.uploadFile(value, (count, total) {
              uploadProgress = count.toDouble() / total.toDouble();
              print("DEBUG=> uploadProgress = $uploadProgress");
              notifyListeners();
            }));
    if (result.isSuccess()) {
      final url = result.getData();
      if (url is String) {
        imageUrl = url;
        print("DEBUG=> uploadUrl = $imageUrl");
        uploadProgress = 0.0;
        updateImageProfileData(imageUrl);
        notifyListeners();
      }
    }
    return result.isSuccess();
  }

  Future<dynamic> updateImageProfileData(String value) async {
    ApiResult result = await API.updateProfileData('icon', value);
    if (result.isSuccess()) {
      _getMyProfileData().then((value) {
        value['info'].addAll(result.getData());
        print("DEBUG=> value result.getData() ${value['info']}");
        // SP.set(SPKey.userInfo, jsonEncode(value));
        UserCentre.saveUserInfo(jsonEncode(value));
      });
    } else {
      showToast('${result.info}');
    }
  }

  Future _getMyProfileData() async {
    String? stored = SP.getString(SPKey.userInfo);
    if (stored != null) {
      print("_myProfileData ${stored}");
      try {
        return jsonDecode(stored);
      } catch (e) {}
    } else {
      showToast('请重新登录');
      SP.delete(SPKey.userInfo);
      Future.delayed(
          Duration(seconds: 1), () => Routers.navigateAndRemoveUntil('/login'));
    }
  }

  void refreshData() {
    _getStoredForMyProfileData();
    notifyListeners();
  }

  @override
  void dispose() {
    imageUrl = "";
    uploadProgress = 0.0;
    super.dispose();
  }
}
