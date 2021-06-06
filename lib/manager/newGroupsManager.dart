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
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/services.dart';
import 'package:hatchery_im/config.dart';
// import 'package:hatchery_im/common/backgroundListenModel.dart';
import '../config.dart';

class NewGroupsManager extends ChangeNotifier {
  String groupAvatarUrl = '';
  double uploadProgress = 0.0;

  // /// 初始化
  // init() {}
  //
  Future<bool> uploadImage(String filePath) async {
    ApiResult result = await compressionImage(filePath)
        .then((value) => API_UPLOAD.uploadImage(value, (count, total) {
              uploadProgress = count.toDouble() / total.toDouble();
              print("DEBUG=> uploadProgress = $uploadProgress");
              notifyListeners();
            }));
    if (result.isSuccess()) {
      final url = result.getData();
      if (url is String) {
        groupAvatarUrl = url;
        print("DEBUG=> uploadUrl = ${groupAvatarUrl}");
        uploadProgress = 0.0;
        notifyListeners();
      }
    }
    return result.isSuccess();
  }

  Future<bool> submit(
    String groupName,
    String groupDescription,
    String groupIcon,
    String notes,
    List<dynamic> members,
  ) async {
    ApiResult result = await API.createNewGroup(
        groupName, groupDescription, groupIcon, notes, members);
    if (result.isSuccess()) {
      print("DEBUG=> result.getData() ${result.getData()}");
      Routers.navigateReplace('/login');
      showToast('创建群组成功');
    } else {
      showToast('创建群组失败');
    }
    return result.isSuccess();
  }

  @override
  void dispose() {
    groupAvatarUrl = '';
    uploadProgress = 0.0;
    super.dispose();
  }
}
