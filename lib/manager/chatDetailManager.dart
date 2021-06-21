import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:record/record.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:collection';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/services.dart';
import 'package:hatchery_im/config.dart';
// import 'package:hatchery_im/common/backgroundListenModel.dart';
import 'package:hatchery_im/common/tools.dart';
import '../config.dart';

class ChatDetailManager extends ChangeNotifier {
  MyProfile? myProfileData;
  bool isVoiceModel = false;
  bool isRecording = false;
  List<FriendsHistoryMessages> messagesList = [];
  String? voicePath;
  String? voiceUrl;
  Timer? timer;
  int recordTiming = 0;

  /// 初始化
  init() {
    _getStoredForMyProfileData();
  }

  queryFriendsHistoryMessages(String friendId, int? currentMsgID,
      {int current = 0, int size = 100}) async {
    API
        .messageHistoryWithFriend(
            friendID: friendId,
            size: size,
            current: current,
            currentMsgID: currentMsgID!)
        .then((value) {
      if (value.isSuccess()) {
        messagesList = value
            .getDataList((m) => FriendsHistoryMessages.fromJson(m), type: 0);
        notifyListeners();
      }
    });
  }

  _getStoredForMyProfileData() async {
    String? stored = SP.getString(SPKey.userInfo);
    if (stored != null) {
      print("_myProfileData ${stored}");
      try {
        var userInfo = MyProfile.fromJson(jsonDecode(stored)['info']);
        myProfileData = userInfo;
        print("_myProfileData ${myProfileData!.userID}");
      } catch (e) {}
    } else {
      showToast('请重新登录');
      SP.delete(SPKey.userInfo);
      Future.delayed(
          Duration(seconds: 1), () => Routers.navigateAndRemoveUntil('/login'));
    }
  }

  changeInputView() {
    if (isVoiceModel) {
      isVoiceModel = false;
    } else {
      isVoiceModel = true;
    }
    notifyListeners();
  }

  startVoiceRecord(String friendId) async {
    bool result = await Record.hasPermission();
    var status = await Permission.storage.status;
    DateTime _timeNow = DateTime.now();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String voiceTempPath = '$tempPath/voiceFiles/';
    folderCreate(voiceTempPath);
    voicePath =
        '$voiceTempPath${friendId}_${_timeNow.millisecondsSinceEpoch}.m4a';

    if (result && status.isDenied) {
      await Record.start(
        path: '$voicePath', // required
      );
      isRecording = true;
    } else {
      showToast('没有录音或者存储权限，请在系统设置中开启');
      isRecording = false;
    }
    notifyListeners();
  }

  stopVoiceRecord() async {
    await Record.stop();
    isRecording = false;
    print("DEBUG=> $recordTiming");
    if (recordTiming >= 2) {
      uploadVoiceFile(voicePath!);
    } else {
      showToast('录制时间太短', showGravity: ToastGravity.BOTTOM);
      if (voicePath != null) deleteFile(voicePath!);
    }
    notifyListeners();
  }

  pauseVoiceRecord() async {
    await Record.pause();
    isRecording = false;
    notifyListeners();
  }

  resumeVoiceRecord() async {
    await Record.resume();
    isRecording = true;
    notifyListeners();
  }

  timingStartMethod() {
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      recordTiming++;
      notifyListeners();
    });
  }

  cancelTimer() {
    timer?.cancel();
    recordTiming = 0;
    isRecording = false;
  }

  uploadVoiceFile(String filePath) async {
    ApiResult result =
        await ApiForFileService.uploadFile(filePath, (count, total) {});
    if (result.isSuccess()) {
      final url = result.getData();
      if (url is String) {
        voiceUrl = url;
        print("DEBUG=> voiceUrl = ${voiceUrl}");
        notifyListeners();
      }
    }
  }
}
