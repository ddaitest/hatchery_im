import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:hatchery_im/manager/app_manager/app_handler.dart';
import 'package:hatchery_im/manager/messageCentre.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:record/record.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hatchery_im/manager/userCentre.dart';
import 'dart:collection';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/services.dart';
import 'package:hatchery_im/config.dart';
// import 'package:hatchery_im/common/backgroundListenModel.dart';
import 'package:hatchery_im/common/tools.dart';
import 'dart:convert' as convert;
import '../../config.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class ChatDetailManager extends ChangeNotifier {
  final TextEditingController textEditingController = TextEditingController();
  MyProfile? myProfileData;
  bool isVoiceModel = false;
  bool isRecording = false;
  bool emojiShowing = false;
  List<Message> messagesList = [];
  String? voicePath;
  String? voiceUrl;
  Timer? timer;
  int recordTiming = 0;

  String currentFriendId = "";
  int currentMessageID = 0;

  /// 初始化
  init(String friendId) {
    _inputTextListen();
    myProfileData = UserCentre.getInfo();
    queryFriendsHistoryMessages(friendId, 0);
    currentFriendId = friendId;
    _loadLatest();
    //添加监听
    MessageCentre().listenMessage((news) {}, friendId);
  }

  Future<void> pickCamera(BuildContext context) async {
    // final Size size = MediaQuery.of(context).size;
    // final double scale = MediaQuery.of(context).devicePixelRatio;
    final AssetEntity? _entity = await CameraPicker.pickFromCamera(
      context,
      enableRecording: true,
      shouldDeletePreviewFile: true,
    );
    if (_entity != null) {
      _entity.file.then((value) {
        if (value!.path.split(".")[1] != 'mp4') {
          messagesList.insert(0, setMediaMessageMap("IMAGE", value.path));
          notifyListeners();
          compressionImage(value.path).then((compressionValue) {
            uploadMediaFile(compressionValue).then((value) => null);
          });
        } else {
          messagesList.insert(0, setMediaMessageMap("VIDEO", value.path));
          notifyListeners();
          messagesList.forEach((element) {
            print("DEBUG=> messagesList${element.content}");
          });
          compressionVideo(value.path).then((compressionValue) {
            uploadMediaFile(compressionValue).then((value) => null);
          });
        }
      });
    }
  }

  Message setMediaMessageMap(String messageType, String mediaUrl) {
    DateTime _timeNow = DateTime.now();
    Map<String, dynamic> map = {
      "id": _timeNow.millisecond,
      "type": "",
      "userMsgID": "",
      "sender": UserCentre.getUserID(),
      "nick": "",
      "receiver": "",
      "icon": "",
      "source": "",
      "content": messageType == 'IMAGE'
          ? convert.jsonEncode({"img_url": "$mediaUrl"})
          : convert.jsonEncode({"video_url": "$mediaUrl"}),
      "createTime": _timeNow.toString(),
      "contentType": messageType
    };
    return Message.fromJson(map);
  }

  Future<String?> uploadMediaFile(String filePath) async {
    ApiResult result =
        await ApiForFileService.uploadFile(filePath, (count, total) {
      var uploadProgress = count.toDouble() / total.toDouble();
      print("DEBUG=> uploadProgress = $uploadProgress");
    });
    if (result.isSuccess()) {
      final url = result.getData();
      if (url is String) {
        print("DEBUG=> mediaUrl = $url");
        return url;
      } else {
        showToast("上传失败，请重试");
      }
    } else {
      showToast("上传失败，请重试");
    }
  }

  _inputTextListen() {
    textEditingController.addListener(() {
      print("DEBUG=> _inputTextListen ${textEditingController.text}");
    });
  }

  /// 加载最新的消息，数据来源 本地。
  _loadLatest() {
    // 读本地
    MessageCentre.getMessages(currentFriendId).then((value) {
      if (value.length > 0) {
        messagesList = value;
        notifyListeners();
      }
      if (value.length < 10) {
        //TODO 本地数据少 读一次历史
        loadMore();
      }
    });
  }

  void setEmojiShowStatus({bool? showStatus}) {
    if (showStatus != null) {
      emojiShowing = showStatus;
    } else {
      emojiShowing = !emojiShowing;
    }
    notifyListeners();
  }

  /// 加载更多历史消息
  loadMore() {
    //TODO 本地数据少 读一次历史
    // MessageCentre().loadMore(currentFriendId)
  }

  queryFriendsHistoryMessages(String friendId, int? currentMsgID,
      {int page = 0, int size = 100}) async {
    API
        .messageHistoryWithFriend(
            friendID: friendId,
            size: size,
            page: page,
            currentMsgID: currentMsgID!)
        .then((value) {
      if (value.isSuccess()) {
        messagesList = value.getDataList((m) => Message.fromJson(m), type: 0);

        notifyListeners();
      }
    });
  }

  // _getStoredForMyProfileData() async {
  //   String? stored = SP.getString(SPKey.userInfo);
  //   if (stored != null) {
  //     print("_myProfileData ${stored}");
  //     try {
  //       var userInfo = MyProfile.fromJson(jsonDecode(stored)['info']);
  //       myProfileData = userInfo;
  //       print("_myProfileData ${myProfileData!.userID}");
  //     } catch (e) {}
  //   } else {
  //     showToast('请重新登录');
  //     SP.delete(SPKey.userInfo);
  //     Future.delayed(
  //         Duration(seconds: 1), () => Routers.navigateAndRemoveUntil('/login'));
  //   }
  // }

  changeInputView() {
    isVoiceModel = !isVoiceModel;
    notifyListeners();
  }

  startVoiceRecord(String friendId) async {
    bool result = await Record().hasPermission();
    PermissionStatus status = await Permission.storage.status;
    DateTime _timeNow = DateTime.now();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String voiceTempPath = '$tempPath/voiceFiles/';
    folderCreate(voiceTempPath);
    voicePath =
        '$voiceTempPath${friendId}_${_timeNow.millisecondsSinceEpoch}.mp3';

    print("DEBUG=> $result / ${status.isDenied}");
    if (result && status.isDenied) {
      await Record().start(
        path: '$voicePath', // required
      );
      isRecording = true;
    } else {
      showToast('没有录音或者存储权限，请在系统设置中开启');
      isRecording = false;
      cancelTimer();
    }
  }

  stopVoiceRecord() async {
    await Record().stop();
  }

  checkTimeLength() {
    print("DEBUG=> recordTiming $recordTiming");
    if (recordTiming >= 3) {
      Future.delayed(Duration(milliseconds: 500), () {
        uploadVoiceFile(voicePath!);
      });
    } else {
      showToast('录制时间太短', showGravity: ToastGravity.BOTTOM);
      if (voicePath != null) deleteFile(voicePath!);
    }
    cancelTimer();
  }

  // pauseVoiceRecord() async {
  //   await Record.pause();
  //   isRecording = false;
  //   notifyListeners();
  // }
  //
  // resumeVoiceRecord() async {
  //   await Record.resume();
  //   isRecording = true;
  //   notifyListeners();
  // }

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
        print("DEBUG=> voiceUrl = $voiceUrl");
        notifyListeners();
      }
    }
  }
}
