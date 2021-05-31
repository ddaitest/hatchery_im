import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:hatchery_im/api/entity.dart';
import 'dart:collection';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/services.dart';
// import 'package:hatchery_im/common/backgroundListenModel.dart';
import 'package:hatchery_im/common/tools.dart';
import '../config.dart';

class RegisterManager extends ChangeNotifier {
  final GlobalKey<FormState> registerInputKey = GlobalKey<FormState>();
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
        .then((value) => API.uploadImage(value, (count, total) {
              uploadProgress = count.toDouble() / total.toDouble();
              print("DEBUG=> uploadProgress = $uploadProgress");
              notifyListeners();
            }));
    if (result.isSuccess()) {
      final url = result.getData();
      if (url is String) {
        uploadUrl = url;
        uploadProgress = 0.0;
        notifyListeners();
      }
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
