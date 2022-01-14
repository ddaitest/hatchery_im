import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:hatchery_im/api/engine/Protocols.dart';
import 'package:hatchery_im/api/engine/entity.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/common/log.dart';
import 'package:hatchery_im/manager/MsgHelper.dart';
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
  int? videoHeight;
  int? videoWidth;
  String? currentChatType;
  String? otherName;
  String? otherIcon;
  String currentGroupId = "";
  String currentGroupName = "";
  String currentGroupIcon = "";
  String? myUserId;
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
  }

  List<Message> loadMessages({Box<Message>? msgBox}) {
    List<Message> tempList = [];
    Log.red(currentFriendId != ""
        ? "listenMessage >> friendId= $currentFriendId  myUserId $myUserId"
        : "listenMessage >> groupId= $currentGroupId  myUserId $myUserId");
    if (msgBox != null) {
      tempList = msgBox.values
          .where((element) => element.type == "CHAT"
              ? (element.receiver == currentFriendId &&
                      element.sender == myUserId) ||
                  (element.sender == currentFriendId &&
                      element.receiver == myUserId)
              : element.groupID == currentGroupId)
          .toList();
    } else {
      tempList = LocalStore.messageBox?.values
              .where((element) => element.type == "CHAT"
                  ? (element.receiver == currentFriendId &&
                          element.sender == myUserId) ||
                      (element.sender == currentFriendId &&
                          element.receiver == myUserId)
                  : element.groupID == currentGroupId)
              .toList() ??
          [];
    }
    if (tempList.isNotEmpty) {
      tempList.sort((a, b) => DateTime.fromMillisecondsSinceEpoch(b.createTime)
          .compareTo(DateTime.fromMillisecondsSinceEpoch(a.createTime)));
      clearUnReadStatus(tempList);
    }
    return tempList;
  }

  /// 清除消息未读状态，会影响首页session的未读和mainTab上的总未读数
  /// messageBox和sessionBox都会刷新数据
  void clearUnReadStatus(List<Message> temp) {
    Session? session = LocalStore.findSession(
        currentFriendId == "" ? currentGroupId : currentFriendId);
    if (session != null) {
      session
        ..unReadCount = 0
        ..save();
    }
    if (temp.isNotEmpty) {
      temp.forEach((element) {
        if (element.sender != myProfileData?.userID &&
            element.progress == MSG_RECEIVED) {
          element
            ..progress = MSG_READ
            ..save();
        }
      });
    }
  }

  /// 加载最新的消息，数据来源 本地。
  // _loadLatest(String otherId) {
  //   List<Message> temp = [];
  //   temp = MessageCentre.getMessages();
  //   // 读本地
  //   if (temp.length > 0) {
  //     // messagesList = value;
  //     notifyListeners();
  //   }
  //   if (temp.length < 10) {
  //     //TODO 本地数据少 读一次历史
  //     loadMore();
  //   }
  // }

  Future<void> pickCamera(BuildContext context) async {
    Navigator.pop(App.navState.currentContext!);
    AssetEntity? _entity =
        await CameraPicker.pickFromCamera(context, enableRecording: true);
    if (_entity == null) {
      return null;
    } else {
      sendLocalMediaMessage(_entity);
    }
  }

  Future<String?> uploadMediaFile(String filePath) async {
    ApiResult result =
        await ApiForFileService.uploadFile(filePath, (count, total) {});
    if (result.isSuccess()) {
      final url = result.getData();
      if (url is String) {
        Log.green("mediaUrl = $url");
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

  void sendLocalMediaMessage(AssetEntity? assetEntity) async {
    if (assetEntity != null) {
      assetEntity.file.then((fileValue) {
        Log.red("fileValue ${fileValue?.path}");
        if (assetEntity.type == AssetType.image) {
          Map<String, dynamic> content = {"img_url": fileValue?.path};
          String msgId = _fakeMediaMessage(convert.jsonEncode(content),
              "IMAGE"); // 假上墙，获取msgId，发送成功后利用msgId更新message
          Log.green("msgId $msgId");
          fileValue?.length().then((lengthValue) {
            if (lengthValue > 2080000) {
              compressionImage(fileValue.path).then((compressionValue) {
                uploadMediaFile(compressionValue).then((uploadMediaUrl) {
                  MessageCentre.sendMessageModel(
                      term: uploadMediaUrl!,
                      chatType: currentChatType!,
                      messageType: "IMAGE",
                      otherName: otherName ?? "",
                      otherIcon: otherIcon ?? "",
                      currentGroupId: currentGroupId,
                      currentGroupName: currentGroupName,
                      currentGroupIcon: currentGroupIcon,
                      currentFriendId: currentFriendId,
                      msgId: msgId);
                });
              });
            } else {
              uploadMediaFile(fileValue.path).then((uploadMediaUrl) {
                MessageCentre.sendMessageModel(
                    term: uploadMediaUrl!,
                    chatType: currentChatType!,
                    messageType: "IMAGE",
                    otherName: otherName ?? "",
                    otherIcon: otherIcon ?? "",
                    currentGroupId: currentGroupId,
                    currentGroupName: currentGroupName,
                    currentGroupIcon: currentGroupIcon,
                    currentFriendId: currentFriendId,
                    msgId: msgId);
              });
            }
          });
        } else if (assetEntity.type == AssetType.video) {
          Map<String, dynamic> content = {"video_url": fileValue?.path ?? ""};
          String msgId =
              _fakeMediaMessage(convert.jsonEncode(content), "VIDEO");
          compressionVideo(fileValue!.path).then((compressionValue) {
            uploadMediaFile(compressionValue).then((uploadMediaUrl) {
              MessageCentre.sendMessageModel(
                  term: uploadMediaUrl!,
                  chatType: currentChatType!,
                  messageType: "VIDEO",
                  otherName: otherName ?? "",
                  otherIcon: otherIcon ?? "",
                  currentGroupId: currentGroupId,
                  currentGroupName: currentGroupName,
                  currentGroupIcon: currentGroupIcon,
                  currentFriendId: currentFriendId,
                  msgId: msgId);
            });
          });
        }
      });
    } else {
      showToast("选择失败请重试");
    }
  }

  void getImageByGallery() async {
    List<AssetEntity>? assets =
        await AssetPicker.pickAssets(App.navState.currentContext!,
                requestType: RequestType.common,
                // maxAssets: 1,
                themeColor: Flavors.colorInfo.mainColor) ??
            [];
    Navigator.pop(App.navState.currentContext!);
    if (assets.isNotEmpty) {
      return null;
    } else {
      assets.forEach((element) {
        sendLocalMediaMessage(element);
      });
    }
  }

  Future<void> pickFile() async {
    Navigator.pop(App.navState.currentContext!);
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      String? msgId;
      Map<String, dynamic> content = {
        "name": "${result.files[0].name}",
        "file_url": result.files[0].path!,
        "content_length": result.files[0].size / 1024
      };
      msgId = _fakeMediaMessage(convert.jsonEncode(content), "FILE");
      uploadMediaFile(result.files[0].path!).then((uploadMediaUrl) {
        if (uploadMediaUrl != "")
          MessageCentre.sendMessageModel(
              term: {
                "name": "${result.files[0].name}",
                "file_url": uploadMediaUrl,
                "content_length": result.files[0].size / 1024
              },
              chatType: currentChatType!,
              messageType: "FILE",
              otherName: otherName ?? "",
              otherIcon: otherIcon ?? "",
              currentGroupId: currentGroupId,
              currentGroupName: currentGroupName,
              currentGroupIcon: currentGroupIcon,
              currentFriendId: currentFriendId,
              msgId: msgId);
      });
    }
  }

  String _fakeMediaMessage(String content, String contentType) {
    if (currentFriendId != "") {
      CSSendMessage msg = Protocols.sendMessage(
          myUserId!,
          myProfileData?.nickName ?? "",
          currentFriendId,
          myProfileData?.icon ?? "",
          TARGET_PLATFORM,
          content,
          contentType);
      Message message = ModelHelper.convertMessage(msg);
      Log.red("_fakeMediaMessage ${msg.toJson()}");
      message..progress = MSG_SENDING;
      LocalStore.addMessage(message);
      return msg.msgId;
    } else {
      CSSendGroupMessage msg = Protocols.sendGroupMessage(
          myUserId!,
          myProfileData?.nickName ?? "",
          myProfileData?.icon ?? "",
          currentGroupId,
          currentGroupName,
          currentGroupIcon,
          TARGET_PLATFORM,
          content,
          contentType);
      Message message = ModelHelper.convertGroupMessage(msg);
      message..progress = MSG_SENDING;
      LocalStore.addMessage(message);
      return msg.msgId;
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
  // loadMore() {
  //   //TODO 本地数据少 读一次历史
  //   // MessageCentre().loadMore(currentFriendId)
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

  sendVoiceMessage() {
    Log.green("recordTiming $recordTiming");
    if (voicePath != null) {
      if (recordTiming >= 3) {
        String? msgId;
        Map<String, dynamic> content = {"voice_url": voicePath};
        msgId = _fakeMediaMessage(convert.jsonEncode(content), "VOICE");
        Future.delayed(Duration(milliseconds: 1000), () {
          uploadMediaFile(voicePath!).then(
            (uploadMediaUrl) => MessageCentre.sendMessageModel(
                term: uploadMediaUrl,
                chatType: currentChatType!,
                messageType: "VOICE",
                otherName: otherName ?? "",
                otherIcon: otherIcon ?? "",
                currentGroupId: currentGroupId,
                currentGroupName: currentGroupName,
                currentGroupIcon: currentGroupIcon,
                currentFriendId: currentFriendId,
                msgId: msgId),
          );
        });
      } else {
        showToast('录制时间太短', showGravity: ToastGravity.BOTTOM);
        if (voicePath != null) deleteFile(voicePath!);
      }
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

  static copyText(String? targetText) {
    if (targetText != null) {
      Clipboard.setData(ClipboardData(text: targetText));
      showToast("复制成功");
    } else {
      showToast("复制失败");
    }
  }

  static relayMessage(
      Map<String, dynamic>? content, String? contentType) async {
    if (content != null && contentType != null) {
      return Routers.navigateTo('/select_contacts_model', arg: {
        'titleText': '转发消息',
        'tipsText': '请至少选择一名好友',
        'leastSelected': 1,
        'nextPageBtnText': '转发',
        'selectContactsType': SelectContactsType.Share,
        'contentType': contentType,
        'shareMessageContent': content,
        'groupMembersFriendId': ['']
      });
    } else {
      showToast("转发失败");
    }
  }

  void disposeModel() {
    isVoiceModel = false;
    voicePath = null;
    voiceUrl = null;
    cancelTimer();
    emojiShowing = false;
    textEditingController.clear();
    currentFriendId = "";
    currentGroupId = "";
    currentGroupName = "";
    currentGroupIcon = "";
  }
}
