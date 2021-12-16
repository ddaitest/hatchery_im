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
import 'package:hive/hive.dart';
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
import 'package:file_picker/file_picker.dart';
import 'package:hatchery_im/common/tools.dart';
import 'dart:convert' as convert;
import '../../config.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class ChatDetailManager extends ChangeNotifier {
  MyProfile? myProfileData;
  bool isVoiceModel = false;
  bool isRecording = false;
  bool emojiShowing = false;
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
  String? currentChatType;
  String? otherName;
  String? otherIcon;
  String currentGroupId = "";
  String currentGroupName = "";
  String currentGroupIcon = "";
  String? myUserId;
  ValueNotifier<List<Message>> messageList = ValueNotifier<List<Message>>([]);
  VideoLoadType videoLoadType = VideoLoadType.Fail;
  final TextEditingController textEditingController = TextEditingController();

  /// 初始化
  init(
      {String? chatType,
      String friendName = "",
      String friendIcon = "",
      String friendId = "",
      String groupId = "",
      String groupName = "",
      String groupIcon = ""}) {
    // _inputTextListen();
    // messageList = ValueNotifier<List<Message>>([]);
    myProfileData = UserCentre.getInfo();
    myUserId = myProfileData?.userID ?? "";
    currentChatType = chatType;
    otherName = friendName;
    otherIcon = friendIcon;
    currentFriendId = friendId;
    currentGroupId = groupId;
    currentGroupName = groupName;
    currentGroupIcon = groupIcon;
    loadMessages();
    LocalStore.listenMessage().addListener(() {
      loadMessages();
    });
  }

  void loadMessages() {
    List<Message> tempList = [];
    Log.red(currentFriendId != ""
        ? "listenMessage >> friendId= $currentFriendId"
        : "listenMessage >> groupId= $currentGroupId");
    tempList = LocalStore.messageBox?.values
            .where((element) => element.type == "CHAT"
                ? (element.receiver == currentFriendId &&
                        element.sender == myUserId) ||
                    (element.sender == currentFriendId &&
                        element.receiver == myUserId)
                : element.groupID == currentGroupId)
            .toList() ??
        [];
    Log.red("tempList tempList ${tempList.length}");
    if (tempList.isNotEmpty) {
      tempList.sort((a, b) => DateTime.fromMillisecondsSinceEpoch(b.createTime)
          .compareTo(DateTime.fromMillisecondsSinceEpoch(a.createTime)));
      messageList.value = tempList;
    }
  }

  /// 加载最新的消息，数据来源 本地。
  _loadLatest(String otherId) {
    // 读本地
    MessageCentre.getMessages(otherId).then((value) {
      if (value.length > 0) {
        // messagesList = value;
        notifyListeners();
      }
      if (value.length < 10) {
        //TODO 本地数据少 读一次历史
        loadMore();
      }
    });
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

  // Message setMediaMessageMap(
  //     DateTime dateTime, String messageType, String mediaUrl) {
  //   Map<String, dynamic> map = {};
  //   map = {
  //     "id": dateTime.millisecondsSinceEpoch,
  //     "type": "",
  //     "userMsgID": "",
  //     "sender": UserCentre.getUserID(),
  //     "nick": "",
  //     "receiver": "",
  //     "icon": "",
  //     "source": "",
  //     "content": convert.jsonEncode(
  //         {messageType == 'VIDEO' ? "video_url" : "img_url": "$mediaUrl"}),
  //     "createTime": dateTime.toString(),
  //     "contentType": messageType
  //   };
  //   print("DEBUG=> messagesList map $map");
  //   return Message.fromJson(map);
  // }

  Future<String?> uploadMediaFile(int id, String filePath) async {
    ApiResult result =
        await ApiForFileService.uploadFile(filePath, (count, total) {
      var uploadProgress = count.toDouble() / total.toDouble();
      // todo 思路1：根据list 的index set map
      // Map<String, dynamic> progressMap = {
      //   "id": id,
      //   "uploadProgress": uploadProgress
      // };
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

  void sendLocalMessage(AssetEntity? assetEntity) async {
    DateTime _timeNow = DateTime.now();
    await assetEntity!.file.then((fileValue) {
      if (assetEntity.type == AssetType.image) {
        print("DEBUG=> fileValue!.path ${fileValue!.path}");
        // messagesList.insert(
        //     0, setMediaMessageMap(_timeNow, "IMAGE", fileValue.path));
        fileValue.length().then((lengthValue) {
          if (lengthValue > 2080000) {
            compressionImage(fileValue.path).then((compressionValue) {
              uploadMediaFile(_timeNow.millisecondsSinceEpoch, compressionValue)
                  .then((uploadMediaUrl) {
                if (uploadMediaUrl != "") sendMessage(uploadMediaUrl!, "IMAGE");
              });
            });
          } else {
            uploadMediaFile(_timeNow.millisecondsSinceEpoch, fileValue.path)
                .then((uploadMediaUrl) {
              if (uploadMediaUrl != "") sendMessage(uploadMediaUrl!, "IMAGE");
            });
          }
        });
      } else if (assetEntity.type == AssetType.video) {
        // messagesList.insert(
        //     0, setMediaMessageMap(_timeNow, "VIDEO", fileValue!.path));
        compressionVideo(fileValue!.path).then((compressionValue) {
          uploadMediaFile(_timeNow.millisecondsSinceEpoch, compressionValue)
              .then((uploadMediaUrl) {
            if (uploadMediaUrl != "") sendMessage(uploadMediaUrl!, "VIDEO");
          });
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
        sendLocalMessage(element);
      });
    }
  }

  Future<void> pickFile() async {
    Navigator.pop(App.navState.currentContext!);
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      DateTime _timeNow = DateTime.now();
      uploadMediaFile(_timeNow.millisecondsSinceEpoch, result.files[0].path!)
          .then((uploadMediaUrl) {
        if (uploadMediaUrl != "")
          sendMessage({
            "name": "${result.files[0].name}",
            "file_url": uploadMediaUrl,
            "content_length": result.files[0].size / 1024
          }, "FILE");
      });
    }
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

  queryFriendsHistoryMessages() async {}

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

  startVoiceRecord() async {
    bool result = await Record().hasPermission();
    PermissionStatus status = await Permission.storage.status;
    DateTime _timeNow = DateTime.now();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String voiceTempPath = '$tempPath/voiceFiles/';
    folderCreate(voiceTempPath);
    voicePath = '${voiceTempPath}_${_timeNow.millisecondsSinceEpoch}.mp3';
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
        DateTime _timeNow = DateTime.now();
        uploadMediaFile(_timeNow.millisecondsSinceEpoch, voicePath!)
            .then((uploadMediaUrl) {
          if (uploadMediaUrl != "") sendMessage(uploadMediaUrl!, "VOICE");
        });
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

  void sendMessage(var term, String messageType) {
    switch (messageType) {
      case "TEXT":
        MessageCentre.sendTextMessage(
          currentChatType!,
          term,
          otherName: otherName,
          otherIcon: otherIcon,
          groupId: currentGroupId,
          groupName: currentGroupName,
          groupIcon: currentGroupIcon,
          friendId: currentFriendId,
        );
        break;
      case "IMAGE":
        MessageCentre.sendImageMessage(
          currentChatType!,
          term,
          otherName: otherName,
          otherIcon: otherIcon,
          groupId: currentGroupId,
          groupName: currentGroupName,
          groupIcon: currentGroupIcon,
          friendId: currentFriendId,
        );
        break;
      case "VIDEO":
        MessageCentre.sendVideoMessage(
          currentChatType!,
          term,
          otherName: otherName,
          otherIcon: otherIcon,
          groupId: currentGroupId,
          groupName: currentGroupName,
          groupIcon: currentGroupIcon,
          friendId: currentFriendId,
        );
        break;
      case "VOICE":
        MessageCentre.sendVoiceMessage(
          currentChatType!,
          term,
          otherName: otherName,
          otherIcon: otherIcon,
          groupId: currentGroupId,
          groupName: currentGroupName,
          groupIcon: currentGroupIcon,
          friendId: currentFriendId,
        );
        break;
      case "GEO":
        MessageCentre.sendGeoMessage(
          currentChatType!,
          term,
          otherName: otherName,
          otherIcon: otherIcon,
          groupId: currentGroupId,
          groupName: currentGroupName,
          groupIcon: currentGroupIcon,
          friendId: currentFriendId,
        );
        break;
      case "FILE":
        MessageCentre.sendFileMessage(
          currentChatType!,
          term,
          otherName: otherName,
          otherIcon: otherIcon,
          groupId: currentGroupId,
          groupName: currentGroupName,
          groupIcon: currentGroupIcon,
          friendId: currentFriendId,
        );
        break;
      default:
        MessageCentre.sendTextMessage(
          currentChatType!,
          term,
          otherName: otherName,
          otherIcon: otherIcon,
          groupId: currentGroupId,
          groupName: currentGroupName,
          groupIcon: currentGroupIcon,
          friendId: currentFriendId,
        );
        break;
    }
  }
}
