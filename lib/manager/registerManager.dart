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
  final GlobalKey<FormState> _registerInputKey = GlobalKey<FormState>();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _nickNameController = TextEditingController();
  final TextEditingController _avatarController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  GlobalKey<FormState> get registerInputKey => _registerInputKey;
  TextEditingController get accountController => _accountController;
  TextEditingController get nickNameController => _nickNameController;
  TextEditingController get avatarController => _avatarController;
  TextEditingController get codeController => _codeController;
  TextEditingController get notesController => _notesController;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get emailController => _emailController;
  TextEditingController get addressController => _addressController;

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
    _accountController.dispose();
    _nickNameController.dispose();
    _avatarController.dispose();
    _codeController.dispose();
    _notesController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
