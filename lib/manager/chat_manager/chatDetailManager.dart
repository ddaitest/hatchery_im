import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/common/log.dart';
import 'package:hatchery_im/manager/app_manager/app_handler.dart';
import 'package:hatchery_im/manager/messageCentre.dart';
import 'package:hatchery_im/store/LocalStore.dart';
import 'package:image_picker/image_picker.dart';
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
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:video_compress/video_compress.dart';

import 'package:hatchery_im/common/tools.dart';
import 'dart:convert' as convert;
import '../../config.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class ChatDetailManager extends ChangeNotifier {
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
  Map<String, dynamic> uploadProgressMaps = {};
  List<Map<String, dynamic>> uploadFailList = [];
  int? videoHeight;
  int? videoWidth;
  AssetEntity? _entity;

  VideoLoadType videoLoadType = VideoLoadType.Fail;
  final TextEditingController textEditingController = TextEditingController();

  // ValueListenable<Box<Message>> messages = LocalStore.listenMessage();
  /// 初始化
  init(String friendId) {
    // _inputTextListen();
    myProfileData = UserCentre.getInfo();
    var myId = UserCentre.getUserID();
    // queryFriendsHistoryMessages(friendId, 0);
    currentFriendId = friendId;
    _loadLatest();
    //添加监听
    // MessageCentre().listenMessage((news) {}, friendId);
    _readMessages(friendId);
    LocalStore.listenMessage().addListener(() {
      _readMessages(friendId);
    });
  }

  void _readMessages(String friendId) {
    Log.red("listenMessage >> friendId =$friendId");
    var temp = LocalStore.messageBox!.values
        .where((element) =>
            element.receiver == friendId || element.sender == friendId)
        .toList();
    if (temp.length != messagesList.length) {
      messagesList = temp;
      notifyListeners();
    }
  }

  Future<void> pickCamera(BuildContext context) async {
    // final Size size = MediaQuery.of(context).size;
    // final double scale = MediaQuery.of(context).devicePixelRatio;
    Navigator.pop(App.navState.currentContext!);
    _entity = await CameraPicker.pickFromCamera(context, enableRecording: true);
    if (_entity == null) {
      return null;
    } else {
      sendLocalMessage(_entity);
    }
  }

  Message setMediaMessageMap(
      DateTime dateTime, String messageType, String mediaUrl) {
    Map<String, dynamic> map = {};
    map = {
      "id": dateTime.millisecondsSinceEpoch,
      "type": "",
      "userMsgID": "",
      "sender": UserCentre.getUserID(),
      "nick": "",
      "receiver": "",
      "icon": "",
      "source": "",
      "content": convert.jsonEncode(
          {messageType == 'VIDEO' ? "video_url" : "img_url": "$mediaUrl"}),
      "createTime": dateTime.toString(),
      "contentType": messageType
    };
    print("DEBUG=> messagesList map $map");
    return Message.fromJson(map);
  }

  Future<String?> uploadMediaFile(int id, String filePath) async {
    ApiResult result =
        await ApiForFileService.uploadFile(filePath, (count, total) {
      var uploadProgress = count.toDouble() / total.toDouble();
      // todo 思路1：根据list 的index set map
      Map<String, dynamic> progressMap = {
        "id": id,
        "uploadProgress": uploadProgress
      };
      print("DEBUG=> uploadProgress = $id $uploadProgress");
    });
    if (result.isSuccess()) {
      final url = result.getData();
      if (url is String) {
        print("DEBUG=> mediaUrl = $url");
        return url;
      } else {
        showToast("上传失败，请重试");
        return '';
      }
    } else {
      showToast("上传失败，请重试");
      return '';
    }
  }

  void sendLocalMessage(AssetEntity? assetEntity) {
    DateTime _timeNow = DateTime.now();
    assetEntity!.file.then((fileValue) {
      if (assetEntity.type == AssetType.image) {
        print("DEBUG=> fileValue!.path ${fileValue!.path}");
        messagesList.insert(
            0, setMediaMessageMap(_timeNow, "IMAGE", fileValue.path));
        fileValue.length().then((lengthValue) {
          if (lengthValue > 2080000) {
            compressionImage(fileValue.path).then((compressionValue) {
              uploadMediaFile(_timeNow.millisecondsSinceEpoch, compressionValue)
                  .then((value) => null);
            });
          } else {
            uploadMediaFile(_timeNow.millisecondsSinceEpoch, fileValue.path)
                .then((value) => null);
          }
        });
      } else if (assetEntity.type == AssetType.video) {
        messagesList.insert(
            0, setMediaMessageMap(_timeNow, "VIDEO", fileValue!.path));
        compressionVideo(fileValue.path).then((compressionValue) {
          uploadMediaFile(_timeNow.millisecondsSinceEpoch, compressionValue)
              .then((value) => null);
        });
      }
    });
  }

  Future getImageByGallery() async {
    final List<AssetEntity>? assets =
        await AssetPicker.pickAssets(App.navState.currentContext!,
            requestType: RequestType.common,
            // maxAssets: 1,
            themeColor: Flavors.colorInfo.mainColor);
    Navigator.pop(App.navState.currentContext!);
    if (assets == null) {
      return null;
    } else {
      assets.forEach((element) {
        Future.delayed(Duration.zero, () {
          VideoCompress.cancelCompression()
              .then((value) => sendLocalMessage(element));
        });
      });
    }
  }

  // _inputTextListen() {
  //   textEditingController.addListener(() {
  //     print("DEBUG=> _inputTextListen ${textEditingController.text}");
  //   });
  // }

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

  void sendTextMessage(String term) {
    MessageCentre.sendTextMessage(currentFriendId, term);
  }
}
