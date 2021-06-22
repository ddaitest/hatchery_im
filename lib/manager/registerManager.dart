import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/common/utils.dart';
// import 'package:hatchery_im/api/entity.dart';
import 'dart:collection';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/services.dart';
// import 'package:hatchery_im/common/backgroundListenModel.dart';
import 'package:hatchery_im/common/tools.dart';
import '../config.dart';

class RegisterManager extends ChangeNotifier {
  TextEditingController accountController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String uploadUrl = "";
  double uploadProgress = 0.0;

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
        uploadUrl = url;
        print("DEBUG=> uploadUrl = ${uploadUrl}");
        uploadProgress = 0.0;
        notifyListeners();
      }
    }
    return result.isSuccess();
  }

  Future<bool> submit(
    String loginName,
    String nickName,
    String avatar,
    String password,
    String notes,
    String phone,
    String email,
    String address,
  ) async {
    ApiResult result = await API.usersRegister(
        loginName, nickName, avatar, password, notes, phone, email, address);
    if (result.isSuccess()) {
      print("DEBUG=> result.getData() ${result.getData()}");
      Routers.navigateAndRemoveUntil('/login');
      showToast('注册成功');
    } else {
      showToast('账号已注册,请更换账号后重试');
    }
    return result.isSuccess();
  }

  @override
  void dispose() {
    accountController.dispose();
    nickNameController.dispose();
    codeController.dispose();
    notesController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
