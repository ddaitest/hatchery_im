import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/common/log.dart';
import 'package:hatchery_im/manager/messageCentre.dart';
import 'package:hatchery_im/manager/userCentre.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/common/utils.dart';
// import 'package:hatchery_im/api/entity.dart';
import 'dart:collection';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/services.dart';
import 'package:hatchery_im/config.dart';
// import 'package:hatchery_im/common/backgroundListenModel.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/store/LocalStore.dart';
import '../../config.dart';

class LoginManager extends ChangeNotifier {
  TextEditingController accountController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController phoneCodeController = TextEditingController();
  String phoneNumber = '';
  String phoneNumberAreaCode = '';
  bool isOTPLogin = false;
  bool finishCountDown = true;
  int countDown = 10;
  Timer? countDownTimer;
  bool isClickLoginBtn = false;

  /// 初始化
  init() {
    countDown = TimeConfig.OTP_CODE_RESEND;
  }

  static hiveDBInit() {
    LocalStore.init().then((_) {
      MessageCentre.init();
      Future.delayed(Duration(milliseconds: 500), () {
        Routers.navigateAndRemoveUntil('/');
      });
    });
  }

  void setOTPLogin() {
    isOTPLogin = !isOTPLogin;
    notifyListeners();
  }

  Future<bool> submit(String account, String password) async {
    if (!isClickLoginBtn) {
      isClickLoginBtn = true;
      ApiResult result = await API.usersLogin(account, password);
      if (result.isSuccess()) {
        print("DEBUG=> result.getData() ${result.getData()['info']}");
        // SP.set(SPKey.userInfo, jsonEncode(result.getData()));
        UserCentre.saveUserInfo(jsonEncode(result.getData()));
        hiveDBInit();
      } else {
        showToast('账号或密码错误');
      }
      isClickLoginBtn = false;
      return result.isSuccess();
    } else {
      return false;
    }
  }

  Future<bool> sendOTP(String userPhone, String areaCode, int sendType) async {
    ApiResult result = await API.sendSMS(userPhone, areaCode, sendType);
    if (result.isSuccess()) {
      print("DEBUG=> result.getData() ${result.getInfo()}");
      otpCountDownTime();
      showToast('发送成功');
    } else {
      showToast('${result.getInfo()}');
    }
    return result.isSuccess();
  }

  Future<bool> phoneSubmit(
      String userPhone, String areaCode, String code) async {
    ApiResult result = await API.phoneLogin(userPhone, areaCode, code);
    if (result.isSuccess()) {
      print("DEBUG=> result.getData() ${result.getData()}");
      // SP.set(SPKey.userInfo, jsonEncode(result.getData()));
      UserCentre.saveUserInfo(jsonEncode(result.getData()));
      hiveDBInit();
    } else {
      showToast('${result.info}');
    }
    return result.isSuccess();
  }

  void otpCountDownTime() {
    // 开始倒计时
    // countDown = TimeConfig.OTP_CODE_RESEND;
    countDownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      countDown = countDown - 1;
      print("countDownTimer_timer $countDown");
      if (countDown < 1) {
        countDown = TimeConfig.OTP_CODE_RESEND;
        timer.cancel();
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    accountController.dispose();
    codeController.dispose();
    phoneCodeController.dispose();
    phoneNumController.dispose();
    countDown = TimeConfig.OTP_CODE_RESEND;
    countDownTimer?.cancel();
    super.dispose();
  }
}
