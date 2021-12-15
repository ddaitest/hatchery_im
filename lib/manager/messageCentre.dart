import 'dart:convert';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/cupertino.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:hatchery_im/api/engine/Protocols.dart';
import 'package:hatchery_im/api/engine/entity.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/Engine.dart';
import 'package:hatchery_im/common/log.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/config.dart';
import 'package:hatchery_im/manager/userCentre.dart';
import 'package:crypto/crypto.dart';
import 'contacts_manager/Constants.dart';
import '../store/LocalStore.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'MsgHelper.dart';
import 'app_manager/app_handler.dart';

typedef SessionListener = void Function(List<Session> news);
typedef MessageListener = void Function(List<Message> news);
typedef NewMessageListener = void Function(Message news);

const LOAD_SIZE = 50;

class MessageCentre {
  static final MessageCentre _singleton = MessageCentre._internal();

  factory MessageCentre() {
    return _singleton;
  }

  MessageCentre._internal();

  ///本地存储
  LocalStore _localStore = LocalStore();

  ///Session
  List<Session>? sessions;

  ///监听 session 变化
  SessionListener? sessionListener;

  MessageListener? messageListener;
  NewMessageListener? newMessageListener;

  String currentListenId = "";

  static Engine? engine;
  static MyProfile? _userInfo;
  static String _token = "";
  static String ipV4 = "0.0.0.0";

  static init() {
    Log.yellow("MessageCentre.init()");
    //获取 session
    try {
      Ipify.ipv4().then((value) => {ipV4 = value});
    } catch (e) {}
    var centre = MessageCentre();
    centre.initSessions();

    //连接 Engine
    engine = Engine.getInstance();
    _userInfo = UserCentre.getInfo();
    _token = UserCentre.getToken();
    if (_userInfo == null) {
      Log.red("MessageCentre.init error _userInfo is null");
      return;
    }
    if (_token.isEmpty) {
      Log.red("MessageCentre.init error _token is $_token");
      return;
    }
    engine?.init('ws://119.23.74.10:5889/ws', _userInfo?.userID ?? "",
        source: TARGET_PLATFORM);
    engine?.connect();
    engine?.setCallback(MyEngineHandler(centre));
    Log.yellow("MessageCentre.init() - finish");
    // sendAuth();
  }

  static Future<List<Message>> getMessages(String friendId) async {
    return [];
  }

  listenSessions(SessionListener listener) {
    sessionListener = listener;
    if (sessions != null) {
      listener(sessions ?? []);
    }
  }

  listenNewMessages(NewMessageListener listener) {
    newMessageListener = listener;
  }

  listenMessage(MessageListener listener, String friendId) {
    currentListenId = friendId;
    messageListener = listener;
  }

  ///获取 session 信息. 然后同步每个session 最新的消息。
  initSessions() async {
    // Step1. 返回本地存储的数据。
    _localStore.getSessions().then((List<Session>? value) {
      sessions = value ?? [];
      Log.yellow("_initSessions 开始");
      Log.yellow("_initSessions Step1. 返回本地存储的数据 ${sessions?.length}");

      // Step2. 从Server获取最新数据。
      API.querySession().then((value) async {
        if (value.isSuccess()) {
          List<Session> serverSessionList =
              value.getDataList((m) => Session.fromJson(m));
          // Step3. 刷新本地数据。
          Log.yellow("_syncNewSessions 同步session");
          _syncNewSessions(serverSessionList);
          sessionListener?.call(sessions ?? []);
          serverSessionList.forEach((element) {
            Log.yellow("_initSessions 从Server获取最新数据 ${element.toJson()}");
          });
          Log.yellow("_syncMessage 同步message");
          _syncNewMessage(serverSessionList);

          // sessions?.forEach((element) {
          //   Log.red("本地sessions ${element.toJson()}");
          // });
        }
      });
      // LocalStore.sortSession();
    });
  }

  ///找出需要同步的session
  _syncNewSessions(List<Session> serverSessionList) {
    List<Session> localSessionList = sessions ?? [];
    serverSessionList.forEach((serverSession) {
      int index = localSessionList.indexWhere(
          (localSession) => localSession.otherID == serverSession.otherID);
      if (index < 0 || localSessionList.isEmpty) {
        _syncSession(null, serverSession, null);
      } else {
        _syncSession(localSessionList[index], serverSession,
            localSessionList[index].otherID);
      }
    });
  }

  ///同步 session 并更新
  _syncSession(Session? before, Session latest, String? otherId) {
    if (before == null) {
      Log.yellow("本地没有session，先创建并填充接口数据");
      // 本地没有session，先创建并填充接口数据
      LocalStore.createNewSession(
          chatType: latest.type == CHAT_TYPE_ONE ? "CHAT" : "GROUP",
          message: latest.type == CHAT_TYPE_ONE
              ? latest.lastChatMessage
              : latest.lastGroupChatMessage,
          sessionOtherId: latest.otherID,
          sessionOwnerId: latest.ownerID,
          sessionTitle: latest.title,
          sessionIcon: latest.icon,
          sessionTime: latest.updateTime);
    } else {
      // 本地有session，更新数据
      if (otherId != null) {
        Session? result = LocalStore.findSession(otherId);
        if (result != null) {
          Log.yellow("本地有session，更新数据");
          latest.type == CHAT_TYPE_ONE
              ? result.lastChatMessage = latest.lastChatMessage
              : result.lastGroupChatMessage = latest.lastGroupChatMessage;
          result
            ..title = latest.title
            ..icon = latest.icon
            ..updateTime = latest.updateTime
            ..save();
        }
      }
    }
    LocalStore.sortSession();
  }

  ///同步message 本地有的忽略，本地没有的加入，最多50条
  _syncNewMessage(List<Session>? serverSessionList) {
    if (serverSessionList != null && serverSessionList.isNotEmpty) {
      serverSessionList.forEach((Session serverSession) {
        if (serverSession.otherID != "") {
          if (serverSession.type == 0) {
            _queryHistoryFriend(serverSession.otherID)
                .then((List<Message>? friendMsg) => _syncMessage(friendMsg));
          } else {
            _queryHistoryGroup(serverSession.otherID)
                .then((List<Message> groupMsg) => _syncMessage(groupMsg));
          }
        }
      });
    }
  }

  _syncMessage(List<Message>? messagesList) async {
    if (messagesList != null) {
      if (messagesList.isNotEmpty) {
        messagesList.forEach((element) {});
      }
    }
  }

  Future<List<Message>> _queryHistoryFriend(String friendID) async {
    ApiResult values = await API.messageHistoryWithFriend(
        friendID: friendID, page: 0, size: LOAD_SIZE);
    List<Message> news = values.getDataList((m) => Message.fromJson(m));
    return news;
  }

  Future<List<Message>> _queryHistoryGroup(String groupID) async {
    ApiResult values =
        await API.getGroupHistory(groupID: groupID, page: 0, size: LOAD_SIZE);
    List<Message> news = values.getDataList((m) => Message.fromJson(m));
    return news;
  }

  // _notifyMessageChanged(String friendID) {}

  static sendAuth() async {
    Log.yellow("sendAuth");
    var infos = DeviceInfo.info.toString();
    var deviceInfo = md5.convert(utf8.encode(infos)).toString();
    engine?.sendProtocol(Protocols.auth(
            TARGET_PLATFORM, _userInfo?.userID ?? "", _token, deviceInfo, ipV4)
        .toJson());
  }

  /// string type //聊天类型（CHAT表示单聊，GROUP表示群聊）
  /// string to //接受者(用户ID)
  /// string content_type
  sendMessage(String to, String content, String otherName, String otherIcon,
      String contentType) {
    CSSendMessage msg = Protocols.sendMessage(
        _userInfo?.userID ?? "",
        _userInfo?.nickName ?? "",
        to,
        _userInfo?.icon ?? "",
        TARGET_PLATFORM,
        content,
        contentType);
    Log.yellow("sendMessage ${msg.toJson()}");
    engine?.sendProtocol(msg.toJson());
    Message message = ModelHelper.convertMessage(msg);
    // message.progress = MSG_SENDING;
    LocalStore.addMessage(message,
        otherId: to,
        ownerId: _userInfo?.userID ?? "",
        sessionName: otherName,
        sessionImage: otherIcon);
  }

  sendGroupMessage(String groupId, String groupName, String groupIcon,
      String content, String contentType) {
    CSSendGroupMessage msg = Protocols.sendGroupMessage(
        _userInfo?.userID ?? "",
        _userInfo!.nickName!,
        _userInfo!.icon!,
        groupId,
        groupName,
        groupIcon,
        TARGET_PLATFORM,
        content,
        contentType);
    engine?.sendProtocol(msg.toJson());
    Message message = ModelHelper.convertGroupMessage(msg);
    // message.progress = MSG_SENDING;
    LocalStore.addMessage(message,
        otherId: groupId,
        ownerId: _userInfo?.userID ?? "",
        sessionName: groupName,
        sessionImage: groupIcon);
  }

  static sendTextMessage(String chatType, String text,
      {String? otherName,
      String? otherIcon,
      String? groupId,
      String? groupName,
      String? groupIcon,
      String? friendId}) {
    chatType == "CHAT"
        ? _singleton.sendMessage(friendId!, jsonEncode({"text": text}),
            otherName ?? "", otherIcon ?? "", "TEXT")
        : _singleton.sendGroupMessage(groupId!, groupName!, groupIcon!,
            jsonEncode({"text": text}), "TEXT");
  }

  static sendImageMessage(String chatType, String imageUrl,
      {String? otherName,
      String? otherIcon,
      String? groupId,
      String? groupName,
      String? groupIcon,
      String? friendId}) {
    chatType == "CHAT"
        ? _singleton.sendMessage(friendId!, jsonEncode({"img_url": imageUrl}),
            otherName ?? "", otherIcon ?? "", "IMAGE")
        : _singleton.sendGroupMessage(groupId!, groupName!, groupIcon!,
            jsonEncode({"img_url": imageUrl}), "IMAGE");
  }

  static sendVideoMessage(String chatType, String videoUrl,
      {String? otherName,
      String? otherIcon,
      String? groupId,
      String? groupName,
      String? groupIcon,
      String? friendId}) {
    chatType == "CHAT"
        ? _singleton.sendMessage(friendId!, jsonEncode({"video_url": videoUrl}),
            otherName ?? "", otherIcon ?? "", "VIDEO")
        : _singleton.sendGroupMessage(groupId!, groupName!, groupIcon!,
            jsonEncode({"video_url": videoUrl}), "VIDEO");
  }

  static sendVoiceMessage(String chatType, String voiceUrl,
      {String? otherName,
      String? otherIcon,
      String? groupId,
      String? groupName,
      String? groupIcon,
      String? friendId}) {
    chatType == "CHAT"
        ? _singleton.sendMessage(friendId!, jsonEncode({"voice_url": voiceUrl}),
            otherName ?? "", otherIcon ?? "", "VOICE")
        : _singleton.sendGroupMessage(groupId!, groupName!, groupIcon!,
            jsonEncode({"voice_url": voiceUrl}), "VOICE");
  }

  static sendGeoMessage(String chatType, Map<String, dynamic> positionMap,
      {String? otherName,
      String? otherIcon,
      String? groupId,
      String? groupName,
      String? groupIcon,
      String? friendId}) {
    chatType == "CHAT"
        ? _singleton.sendMessage(friendId!, jsonEncode(positionMap),
            otherName ?? "", otherIcon ?? "", "GEO")
        : _singleton.sendGroupMessage(
            groupId!, groupName!, groupIcon!, jsonEncode(positionMap), "GEO");
  }

  static sendFileMessage(String chatType, Map<String, dynamic> fileMap,
      {String? otherName,
      String? otherIcon,
      String? groupId,
      String? groupName,
      String? groupIcon,
      String? friendId}) {
    chatType == "CHAT"
        ? _singleton.sendMessage(friendId!, jsonEncode(fileMap),
            otherName ?? "", otherIcon ?? "", "FILE")
        : _singleton.sendGroupMessage(
            groupId!, groupName!, groupIcon!, jsonEncode(fileMap), "FILE");
  }

  static void disconnect() => engine?.disconnect();
}

class MyEngineHandler implements EngineCallback {
  MessageCentre _centre;

  MyEngineHandler(this._centre);

  @override
  void onMessageRead(String localId, String serverId) {
    Message? msg = LocalStore.findCache(localId);
    if (msg != null) {
      // msg.progress = MSG_READ;
      msg.save();
    }
  }

  @override
  void onMessageSent(String localId, String serverId) {
    Message? msg = LocalStore.findCache(localId);
    if (msg != null) {
      // msg.progress = MSG_SENT;
      msg.save();
    }
  }

  @override
  void onFriendApply(SCFriendApply data) {
    // TODO: implement onFriendApply
  }

  @override
  void onFriendResult(SCFriendResult data) {
    // TODO: implement onFriendResult
  }

  @override
  void onGroupCreated(SCGroupCreate data) {
    // TODO: implement onGroupCreated
  }

  @override
  void onGroupJoin(SCGroupJoin data) {
    // TODO: implement onGroupJoin
  }

  @override
  void onGroupKick(SCGroupKick data) {
    // TODO: implement onGroupKick
  }

  @override
  void onGroupRemove(SCGroupRemove data) {
    // TODO: implement onGroupRemove
  }

  @override
  void onGroupUpdate(SCGroupUpdate data) {
    // TODO: implement onGroupUpdate
  }

  @override
  void onKickOut(SCKickOut data) {
    // TODO: implement onKickOut
  }

  @override
  void onNewMessage(Message msg) {
    _centre.newMessageListener?.call(msg);
    Log.red("onNewMessage onNewMessage");
    LocalStore.addMessage(msg,
        otherId: msg.type == "CHAT" ? msg.sender : msg.groupID,
        ownerId: msg.sender,
        sessionName: msg.nick,
        sessionImage: msg.icon);
  }
}
