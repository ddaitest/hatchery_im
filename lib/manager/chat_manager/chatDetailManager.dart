import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:hatchery_im/api/engine/Protocols.dart';
import 'package:hatchery_im/api/engine/entity.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/common/Engine.dart';
import 'package:hatchery_im/common/log.dart';
import 'package:hatchery_im/manager/MsgHelper.dart';
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
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hatchery_im/manager/userCentre.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/config.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hatchery_im/common/tools.dart';
import 'dart:convert' as convert;
import '../../common/widget/loading_Indicator.dart';
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
  List<Message> messageList = [];
  List<GroupMembers> groupMembersList = [];
  final TextEditingController textEditingController = TextEditingController();
  ValueListenable<Box<Message>>? valueListenable = LocalStore.listenMessage();
  int _oldInputTextLength = 0;
  Map<String, String> _atMemberMap = {};

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
    textEditingController.addListener(() {
      _atTextListenMethod();
    });
    _loadMessages(firstLoad: true);
    valueListenable?.addListener(() {
      _loadMessages();
    });
  }

  void _loadMessages({bool firstLoad = false}) {
    Box<Message>? msgBox = LocalStore.messageBox;
    List<Message> tempList = [];
    Log.red(currentFriendId != ""
        ? "listenMessage >> friendId= $currentFriendId  myUserId $myUserId"
        : "listenMessage >> groupId= $currentGroupId  myUserId $myUserId");
    if (msgBox != null) {
      tempList = msgBox.values
          .where((element) =>
              (element.deleted == null || !element.deleted!) &&
              (element.type == "CHAT"
                  ? (element.receiver == currentFriendId &&
                          element.sender == myUserId) ||
                      (element.sender == currentFriendId &&
                          element.receiver == myUserId)
                  : element.groupID == currentGroupId))
          .toList();
      if (tempList.isNotEmpty) {
        tempList.sort((a, b) =>
            DateTime.fromMillisecondsSinceEpoch(b.createTime)
                .compareTo(DateTime.fromMillisecondsSinceEpoch(a.createTime)));
        clearUnReadStatus(tempList);
        messageList = tempList;
        if (!firstLoad) notifyListeners();
      }
    }
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
          Map<String, dynamic> content = {
            "img_url": fileValue?.path,
            "width": assetEntity.width,
            "height": assetEntity.height
          };
          String msgId = _fakeMediaMessage(convert.jsonEncode(content),
              "IMAGE"); // 假上墙，获取msgId，发送成功后利用msgId更新message
          Log.green("content ${content.toString()}");
          _uploadMediaModel(
              filePath: fileValue?.path,
              contentType: "IMAGE",
              content: content,
              msgId: msgId);
        } else if (assetEntity.type == AssetType.video) {
          getVideoThumb(fileValue!.path).then((videoThumbPath) {
            Map<String, dynamic> content = {
              "video_url": fileValue.path,
              "video_thum_url": videoThumbPath,
              "time": assetEntity.videoDuration.inSeconds.toString(),
              "width": assetEntity.width,
              "height": assetEntity.height
            };
            String msgId =
                _fakeMediaMessage(convert.jsonEncode(content), "VIDEO");
            _uploadMediaModel(
                filePath: fileValue.path,
                contentType: "VIDEO",
                content: content,
                msgId: msgId);
          });
        }
      });
    } else {
      showToast("选择失败请重试");
    }
  }

  void _uploadMediaModel(
      {required String? filePath,
      required String contentType,
      required Map<String, dynamic> content,
      required String msgId}) {
    if (filePath != null) {
      if (contentType == "IMAGE") {
        compressionImage(filePath).then((compressionValue) {
          uploadMediaFile(compressionValue).then((uploadMediaUrl) {
            if (uploadMediaUrl != "") {
              content["img_url"] = uploadMediaUrl;
              MessageCentre.sendMessageModel(
                  term: content,
                  chatType: currentChatType!,
                  messageType: contentType,
                  otherName: otherName ?? "",
                  otherIcon: otherIcon ?? "",
                  currentGroupId: currentGroupId,
                  currentGroupName: currentGroupName,
                  currentGroupIcon: currentGroupIcon,
                  currentFriendId: currentFriendId,
                  msgId: msgId);
            } else {
              LocalStore.findCache(msgId)
                ?..progress = MSG_FAULT
                ..save();
            }
          });
        });
      } else if (contentType == "VIDEO") {
        compressionVideo(filePath).then((compressionVideoPath) {
          uploadMediaFile(content["video_thum_url"]).then((videoThumbUrl) {
            uploadMediaFile(compressionVideoPath).then((videoUrl) {
              if (videoUrl != "") {
                content["video_url"] = videoUrl;
                content["video_thum_url"] = videoThumbUrl;
                MessageCentre.sendMessageModel(
                    term: content,
                    chatType: currentChatType!,
                    messageType: contentType,
                    otherName: otherName ?? "",
                    otherIcon: otherIcon ?? "",
                    currentGroupId: currentGroupId,
                    currentGroupName: currentGroupName,
                    currentGroupIcon: currentGroupIcon,
                    currentFriendId: currentFriendId,
                    msgId: msgId);
              } else {
                LocalStore.findCache(msgId)
                  ?..progress = MSG_FAULT
                  ..save();
              }
            });
          });
        });
      } else if (contentType == "VOICE") {
        uploadMediaFile(filePath).then(
          (uploadMediaUrl) {
            content["voice_url"] = uploadMediaUrl;
            Log.green(content.toString());
            MessageCentre.sendMessageModel(
                term: content,
                chatType: currentChatType!,
                messageType: contentType,
                otherName: otherName ?? "",
                otherIcon: otherIcon ?? "",
                currentGroupId: currentGroupId,
                currentGroupName: currentGroupName,
                currentGroupIcon: currentGroupIcon,
                currentFriendId: currentFriendId,
                msgId: msgId);
          },
        );
      } else if (contentType == "FILE") {
        uploadMediaFile(filePath).then((uploadMediaUrl) {
          if (uploadMediaUrl != "") {
            MessageCentre.sendMessageModel(
                term: content,
                chatType: currentChatType!,
                messageType: contentType,
                otherName: otherName ?? "",
                otherIcon: otherIcon ?? "",
                currentGroupId: currentGroupId,
                currentGroupName: currentGroupName,
                currentGroupIcon: currentGroupIcon,
                currentFriendId: currentFriendId,
                msgId: msgId);
          } else {
            LocalStore.findCache(msgId)
              ?..progress = MSG_FAULT
              ..save();
          }
        });
      } else {
        showToast("无法识别请重试");
      }
    } else {
      String toastText = "";
      if (contentType == "IMAGE") {
        toastText = "图片";
      } else if (contentType == "VIDEO") {
        toastText = "视频";
      } else if (contentType == "VOICE") {
        toastText = "语音";
      } else if (contentType == "FILE") {
        toastText = "文件";
      }
      showToast("$toastText选择失败请重试");
    }
  }

  void sendTextMessage({required Map<String, dynamic> content}) {
    String msgId = _fakeMediaMessage(convert.jsonEncode(content),
        "TEXT"); // 假上墙，获取msgId，发送成功后利用msgId更新message
    MessageCentre.sendMessageModel(
        term: content,
        chatType: currentChatType!,
        messageType: "TEXT",
        otherName: otherName ?? "",
        otherIcon: otherIcon ?? "",
        currentGroupId: currentGroupId,
        currentGroupName: currentGroupName,
        currentGroupIcon: currentGroupIcon,
        currentFriendId: currentFriendId,
        msgId: msgId);
  }

  void retrySendMessage(
      {required Map<String, dynamic> content,
      required String messageType,
      required String msgId}) {
    // 重试前先重连长链接
    Engine.getInstance().reconnect();
    String? mediaPath;
    if (messageType == "IMAGE") {
      mediaPath = content["img_url"];
    } else if (messageType == "VIDEO") {
      mediaPath = content["video_url"];
    } else if (messageType == "VOICE") {
      mediaPath = content["voice_url"];
    } else if (messageType == "FILE") {
      mediaPath = content["file_url"];
    } else {
      mediaPath = "";
    }
    if (mediaPath != null) {
      if (messageType == "TEXT" ||
          messageType == "CARD" ||
          messageType == "GEO" ||
          messageType == "URL") {
        Log.green("retrySendMessage $messageType");
        MessageCentre.sendMessageModel(
            term: content,
            chatType: currentChatType!,
            messageType: messageType,
            otherName: otherName ?? "",
            otherIcon: otherIcon ?? "",
            currentGroupId: currentGroupId,
            currentGroupName: currentGroupName,
            currentGroupIcon: currentGroupIcon,
            currentFriendId: currentFriendId,
            msgId: msgId);
      } else {
        if (mediaPath.contains("http")) {
          MessageCentre.sendMessageModel(
              term: content,
              chatType: currentChatType!,
              messageType: messageType,
              otherName: otherName ?? "",
              otherIcon: otherIcon ?? "",
              currentGroupId: currentGroupId,
              currentGroupName: currentGroupName,
              currentGroupIcon: currentGroupIcon,
              currentFriendId: currentFriendId,
              msgId: msgId);
        } else {
          _uploadMediaModel(
              filePath: mediaPath,
              contentType: messageType,
              content: content,
              msgId: msgId);
        }
      }
    } else {
      showToast("重新发送失败，请重新发送");
      LocalStore.findCache(msgId)
        ?..deleted = true
        ..save();
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
    if (assets.isEmpty) {
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
      Map<String, dynamic> content = {
        "name": "${result.files[0].name}",
        "file_url": result.files[0].path!,
        "content_length": result.files[0].size / 1024
      };
      String? msgId = _fakeMediaMessage(convert.jsonEncode(content), "FILE");
      _uploadMediaModel(
          filePath: result.files[0].path!,
          contentType: "FILE",
          content: content,
          msgId: msgId);
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
      Log.red("_fakeMediaMessage userMsgID ${message.createTime}");
      message..progress = MSG_SENDING;
      LocalStore.addMessage(message);
      return message.userMsgID;
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
      return message.userMsgID;
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

  void startVoiceRecord() async {
    try {
      bool result = await Record().hasPermission();
      DateTime _timeNow = DateTime.now();
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      String voiceTempPath = '$tempPath/voiceFiles/';
      folderCreate(voiceTempPath);
      voicePath = '${voiceTempPath}_${_timeNow.millisecondsSinceEpoch}.mp3';
      Log.green("startVoiceRecord $result");
      if (result) {
        await Record().start(
          path: '$voicePath', // required
        );
        isRecording = true;
        changeInputView();
        timingStartMethod();
      } else {
        showToast('没有麦克风或者存储权限，请在系统设置中开启');
        isRecording = false;
        cancelTimer();
      }
    } catch (e) {
      isRecording = false;
      showToast('没有麦克风或者存储权限，请在系统设置中开启');
      cancelTimer();
    }
  }

  stopVoiceRecord() async {
    if (isRecording) {
      await Record().stop();
      sendVoiceMessage();
      changeInputView();
    }
    cancelTimer();
  }

  sendVoiceMessage() {
    Log.green("recordTiming $recordTiming");
    if (voicePath != null) {
      if (recordTiming >= 3) {
        Map<String, dynamic> content = {
          "voice_url": voicePath,
          "time": recordTiming
        };
        String? msgId = _fakeMediaMessage(convert.jsonEncode(content), "VOICE");
        Future.delayed(Duration(milliseconds: 500), () {
          _uploadMediaModel(
              filePath: voicePath,
              contentType: "VOICE",
              content: content,
              msgId: msgId);
        });
      } else {
        showToast('录制时间太短', showGravity: ToastGravity.BOTTOM);
        if (voicePath != null) deleteFile(voicePath!);
      }
    }
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
      });
    } else {
      showToast("转发失败");
    }
  }

  Future<dynamic> _getGroupMembersData() async {
    ApiResult result = await API.getGroupMembers(currentGroupId);
    if (result.isSuccess()) {
      groupMembersList =
          result.getDataList((m) => GroupMembers.fromJson(m), type: 1);
      print("DEBUG=> getGroupMembersData result.getData() $groupMembersList");
      notifyListeners();
    } else {
      showToast('${result.info}');
    }
  }

  void showGroupMemberModal() {
    _getGroupMembersData().then((_) {
      showModalBottomSheet(
          context: App.navState.currentContext!,
          builder: (context) {
            return Container(
                height: Flavors.sizesInfo.screenHeight / 2,
                color: Color(0xff737373),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20)),
                    ),
                    child: Column(children: <Widget>[
                      SizedBox(
                        height: 16.0.h,
                      ),
                      Container(
                        height: 4.0.h,
                        width: 50.0.w,
                        color: Colors.grey.shade200,
                      ),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      Container(
                        child: Text(
                          "选择要提醒的人",
                          style: Flavors.textStyles.chatDetailAppBarNameText,
                        ),
                      ),
                      Expanded(
                        child: Selector<ChatDetailManager, List<GroupMembers>>(
                          builder: (BuildContext context,
                              List<GroupMembers> value, Widget? child) {
                            return value.isNotEmpty
                                ? ListView.builder(
                                    itemCount: value.length,
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () => atSomeOneMethod(
                                            value[index].nickName!,
                                            value[index].userID!),
                                        child: Container(
                                          color: Colors.white,
                                          padding: EdgeInsets.only(
                                              left: 15.0, top: 15.0),
                                          child: Row(
                                            children: <Widget>[
                                              CachedNetworkImage(
                                                  imageUrl: value[index].icon!,
                                                  placeholder: (context, url) =>
                                                      CircleAvatar(
                                                        backgroundImage: AssetImage(
                                                            'images/default_avatar.png'),
                                                        maxRadius: 20,
                                                      ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      CircleAvatar(
                                                        backgroundImage: AssetImage(
                                                            'images/default_avatar.png'),
                                                        maxRadius: 20,
                                                      ),
                                                  imageBuilder:
                                                      (context, imageProvider) {
                                                    return CircleAvatar(
                                                      backgroundImage:
                                                          imageProvider,
                                                      maxRadius: 20,
                                                    );
                                                  }),
                                              SizedBox(
                                                width: 16.0.w,
                                              ),
                                              Container(
                                                color: Colors.transparent,
                                                width: Flavors
                                                        .sizesInfo.screenWidth -
                                                    100.0.w,
                                                child: Text(
                                                    value[index].nickName ?? "",
                                                    style: Flavors
                                                        .textStyles.friendsText,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : IndicatorView();
                          },
                          selector: (BuildContext context,
                              ChatDetailManager chatDetailManager) {
                            return chatDetailManager.groupMembersList;
                          },
                          shouldRebuild: (pre, next) => (pre != next),
                        ),
                      )
                    ])));
          });
    });
  }

  void atSomeOneMethod(String nickName, String userId) {
    textEditingController
      ..text += nickName + " "
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
    _atMemberMap[nickName] = userId;
    Navigator.pop(App.navState.currentContext!);
  }

  void _atTextListenMethod() {
    String temp = textEditingController.text;
    if (temp.length > 0 && currentGroupId != "") {
      Log.green("##### ${temp.characters.last} ${temp.length}");
      if (temp.characters.last == "@" && temp.length > _oldInputTextLength) {
        showToast("@@@@@@@@@@");
        showGroupMemberModal();
      }
    }
    _atMemberMap.keys.forEach((element) {
      String finalKey = "@$element ";
      if (!finalKey.contains(temp)) {
        _atMemberMap.remove(element);
      }
    });
    Log.green("final atMemberMap ${_atMemberMap.toString()}");
    _oldInputTextLength = temp.length;
  }

  void disposeModel() {
    messageList.clear();
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
    valueListenable?.removeListener(() {
      valueListenable = null;
    });
  }
}
