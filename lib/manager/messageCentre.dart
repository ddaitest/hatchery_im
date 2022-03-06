import 'dart:convert';
import 'package:just_audio/just_audio.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:collection/collection.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:hatchery_im/api/engine/Protocols.dart';
import 'package:hatchery_im/api/engine/entity.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/common/Engine.dart';
import 'package:hatchery_im/common/log.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/config.dart';
import 'package:hatchery_im/manager/settingCentre.dart';
import 'package:hatchery_im/manager/userCentre.dart';
import 'package:crypto/crypto.dart';
import 'package:vibration/vibration.dart';
import 'contacts_manager/Constants.dart';
import '../store/LocalStore.dart';
import 'MsgHelper.dart';
import 'devicesInfoCentre.dart';
import 'login_manager/loginManager.dart';
import 'dart:convert' as convert;

typedef SessionListener = void Function(List<Session> news);
typedef MessageListener = void Function(List<Message> news);
typedef NewMessageListener = void Function(Message news);

const LOAD_SIZE = 20;
const LOAD_OFFLINE_SIZE = 100;

class MessageCentre {
  static final MessageCentre _singleton = MessageCentre._internal();

  factory MessageCentre() {
    return _singleton;
  }

  MessageCentre._internal();

  ///本地存储
  // LocalStore _localStore = LocalStore();

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

  ///传otherId搜索对应message；不传otherId搜索全部message
  static List<Message> getMessages({String? otherId}) {
    if (otherId != null) {
      return LocalStore.messageBox?.values
              .where((element) => element.type == "CHAT"
                  ? element.sender == otherId &&
                      element.receiver == UserCentre.getUserID()
                  : element.groupID == otherId)
              .toList() ??
          [];
    } else {
      return LocalStore.messageBox?.values.toList() ?? [];
    }
  }

  static deleteMessage(int? messageKey) {
    if (messageKey != null) {
      Log.yellow("deleteMessage. deleteMessage ");
      LocalStore.messageBox?.get(messageKey)
        ?..deleted = true
        ..save();
      return;
    } else {
      showToast("删除失败");
    }
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
    LocalStore.getSessions().then((List<Session>? localSessionList) {
      sessions = localSessionList ?? [];
      Log.yellow("_initSessions 开始");
      Log.yellow("_initSessions Step1. 返回本地存储的数据 ${localSessionList?.length}");

      // Step2. 从Server获取最新数据。
      API.querySession().then((value) async {
        if (value.isSuccess()) {
          List<Session> serverSessionList =
              value.getDataList((m) => Session.fromJson(m));
          // Step3. 刷新本地数据。
          Log.yellow("_syncNewSessions 同步session");
          _syncNewSessions(serverSessionList, localSessionList ?? []);
          sessionListener?.call(sessions ?? []);
          serverSessionList.forEach((element) {
            Log.yellow("_initSessions 从Server获取最新数据 ${element.toJson()}");
          });
          Log.yellow("_syncMessage 同步message");
        }
      });
    });
  }

  ///找出需要同步的session
  _syncNewSessions(
      List<Session> serverSessionList, List<Session> localSessionList) {
    LoginManager _loginManager = App.manager<LoginManager>();
    if (serverSessionList.isNotEmpty) {
      if (localSessionList.isEmpty) {
        Log.yellow("_syncNewSessions localSessionList.isEmpty");
        serverSessionList.forEach((serverSession) => {
              _syncSession(null, serverSession, null),
              if (_loginManager.isFirstLogin) {_syncNewMessage(serverSession)}
            });
      } else {
        Log.yellow("_syncNewSessions localSessionList.isNotEmpty");
        serverSessionList.forEach((serverSession) {
          Session? session = localSessionList.firstWhereOrNull(
              (localSession) => serverSession.otherID == localSession.otherID);
          if (session != null) {
            _syncSession(session, serverSession, serverSession.otherID);
          } else {
            _syncSession(null, serverSession, null);
          }
          if (_loginManager.isFirstLogin) {
            _syncNewMessage(serverSession);
          }
        });
      }
    }
    if (!_loginManager.isFirstLogin) {
      loadOfflineMessage();
    }
  }

  ///同步 session 并更新
  _syncSession(Session? before, Session latest, String? otherId) {
    if (before == null) {
      Log.yellow("本地没有session，先创建并填充接口数据");
      // 本地没有session，先创建并填充接口数据
      Session? result = LocalStore.findSession(latest.otherID);
      if (result == null) {
        LocalStore.refreshSession(
            latest.type == CHAT_TYPE_ONE
                ? latest.lastChatMessage ?? null
                : latest.lastGroupChatMessage ?? null,
            latest.otherID,
            sessionTime: latest.updateTime);
      }
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

  ///同步message 本地有的忽略，本地没有的加入，最多50条，deleted标记为ture的忽略
  _syncNewMessage(Session? serverSession) {
    if (serverSession != null && serverSession.otherID != "") {
      List<Message> localMessageList =
          LocalStore.messageBox?.values.toList() ?? [];

      if (serverSession.type == 0) {
        _queryHistoryFriend(serverSession.otherID)
            .then((List<Message>? msgList) {
          Log.red("_queryHistoryFriend ${msgList?.length}");
          if (msgList != null && msgList.isNotEmpty) {
            if (localMessageList.isEmpty) {
              LocalStore.messageBox?.addAll(msgList);
            } else {
              _syncMessage(msgList);
            }
          }
        });
      } else {
        _queryHistoryGroup(serverSession.otherID)
            .then((List<Message>? msgList) {
          if (msgList != null && msgList.isNotEmpty) {
            if (localMessageList.isEmpty) {
              LocalStore.messageBox?.addAll(msgList);
            } else {
              _syncMessage(msgList);
            }
          }
        });
      }
    }
  }

  _syncMessage(List<Message>? messagesList) async {
    if (messagesList != null) {
      if (messagesList.isNotEmpty) {
        messagesList.forEach((element) => saveMessage(element));
      }
    }
  }

  void loadOfflineMessage() {
    _queryFriendOffline().then((List<Message>? msgList) {
      Log.red("_queryFriendOffline ${msgList?.length}");
      if (msgList != null && msgList.isNotEmpty) {
        _syncMessage(msgList);
      }
    });
    _queryGroupOffline().then((List<Message>? msgList) {
      Log.green("_queryGroupOffline ${msgList?.length}");
      if (msgList != null && msgList.isNotEmpty) {
        _syncMessage(msgList);
      }
    });
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

  Future<List<Message>> _queryFriendOffline() async {
    ApiResult values =
        await API.getChatOffline(page: 0, size: LOAD_OFFLINE_SIZE);
    List<Message> news = values.getDataList((m) => Message.fromJson(m));
    return news;
  }

  Future<List<Message>> _queryGroupOffline() async {
    ApiResult values =
        await API.getGroupOffline(page: 0, size: LOAD_OFFLINE_SIZE);
    List<Message> news = values.getDataList((m) => Message.fromJson(m));
    return news;
  }

  /// 保存信息：根据id找到messageBox没有的数据并add进messageBox
  static void saveMessage(Message serverMessage) {
    Message? msg = LocalStore.messageBox?.values.firstWhereOrNull(
        (element) => element.deleted != true && element.id == serverMessage.id);
    if (msg != null) {
      Log.red("saveMessage ${msg.id} ${serverMessage.id}");
      LocalStore.addMessage(serverMessage);
    }
  }

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
  static sendMessage(String to, String content, String otherName,
      String otherIcon, String contentType,
      {String? msgId}) {
    CSSendMessage msg = Protocols.sendMessage(
        _userInfo?.userID ?? "",
        _userInfo?.nickName ?? "",
        to,
        _userInfo?.icon ?? "",
        TARGET_PLATFORM,
        content,
        contentType,
        msgId: msgId);
    engine?.sendProtocol(msg.toJson());
    Message message = ModelHelper.convertMessage(msg);
    Log.green("sendMessage sendMessage ${msg.contentType}");
    if (msgId == null) {
      message..progress = MSG_SENDING;
      LocalStore.addMessage(message);
    } else {
      LocalStore.findCache(message.userMsgID)
        ?..content = content
        ..save();
    }
    LocalStore.refreshSession(message, to, sessionTime: message.createTime);
    isNetworkConnect().then((bool isConnect) {
      if (!isConnect) {
        LocalStore.findCache(message.userMsgID)
          ?..progress = MSG_FAULT
          ..save();
        showToast("无网络，请联网后重试");
      }
    });
  }

  static sendGroupMessage(String groupId, String groupName, String groupIcon,
      String content, String contentType,
      {String? msgId}) {
    /// 先判断是否联网，不联网message
    CSSendGroupMessage msg = Protocols.sendGroupMessage(
        _userInfo?.userID ?? "",
        _userInfo?.nickName ?? "",
        _userInfo?.icon ?? "",
        groupId,
        groupName,
        groupIcon,
        TARGET_PLATFORM,
        content,
        contentType,
        msgId: msgId);
    engine?.sendProtocol(msg.toJson());
    Message message = ModelHelper.convertGroupMessage(msg);
    if (msgId == null) {
      Log.yellow("sendGroupMessage ${message.progress} ${msg.toJson()}");
      message..progress = MSG_SENDING;
      LocalStore.addMessage(message);
    } else {
      LocalStore.findCache(msgId)
        ?..content = content
        ..save();
    }
    LocalStore.refreshSession(message, groupId,
        sessionTime: message.createTime);
    isNetworkConnect().then((bool isConnect) {
      if (!isConnect) {
        LocalStore.findCache(message.userMsgID)
          ?..progress = MSG_FAULT
          ..save();
        showToast("无网络，请联网后重试");
      }
    });
  }

  static sendMessageModel(
      {required var term,
      required String chatType,
      required String messageType,
      required String otherName,
      required String otherIcon,
      required String currentGroupId,
      required String currentGroupName,
      required String currentGroupIcon,
      required String currentFriendId,
      String? msgId}) {
    switch (messageType) {
      case "TEXT":
        MessageCentre.sendTextMessage(chatType, term,
            otherName: otherName,
            otherIcon: otherIcon,
            groupId: currentGroupId,
            groupName: currentGroupName,
            groupIcon: currentGroupIcon,
            friendId: currentFriendId,
            msgId: msgId);
        break;
      case "IMAGE":
        MessageCentre.sendImageMessage(chatType, term,
            otherName: otherName,
            otherIcon: otherIcon,
            groupId: currentGroupId,
            groupName: currentGroupName,
            groupIcon: currentGroupIcon,
            friendId: currentFriendId,
            msgId: msgId);
        break;
      case "VIDEO":
        MessageCentre.sendVideoMessage(chatType, term,
            otherName: otherName,
            otherIcon: otherIcon,
            groupId: currentGroupId,
            groupName: currentGroupName,
            groupIcon: currentGroupIcon,
            friendId: currentFriendId,
            msgId: msgId);
        break;
      case "VOICE":
        MessageCentre.sendVoiceMessage(chatType, term,
            otherName: otherName,
            otherIcon: otherIcon,
            groupId: currentGroupId,
            groupName: currentGroupName,
            groupIcon: currentGroupIcon,
            friendId: currentFriendId,
            msgId: msgId);
        break;
      case "GEO":
        MessageCentre.sendGeoMessage(chatType, term,
            otherName: otherName,
            otherIcon: otherIcon,
            groupId: currentGroupId,
            groupName: currentGroupName,
            groupIcon: currentGroupIcon,
            friendId: currentFriendId,
            msgId: msgId);
        break;
      case "FILE":
        MessageCentre.sendFileMessage(chatType, term,
            otherName: otherName,
            otherIcon: otherIcon,
            groupId: currentGroupId,
            groupName: currentGroupName,
            groupIcon: currentGroupIcon,
            friendId: currentFriendId,
            msgId: msgId);
        break;
      case "CARD":
        MessageCentre.sendCardMessage(chatType, term,
            otherName: otherName,
            otherIcon: otherIcon,
            groupId: currentGroupId,
            groupName: currentGroupName,
            groupIcon: currentGroupIcon,
            friendId: currentFriendId,
            msgId: msgId);
        break;
      default:
        MessageCentre.sendTextMessage(chatType, term,
            otherName: otherName,
            otherIcon: otherIcon,
            groupId: currentGroupId,
            groupName: currentGroupName,
            groupIcon: currentGroupIcon,
            friendId: currentFriendId,
            msgId: msgId);
        break;
    }
  }

  static sendTextMessage(String chatType, Map<String, dynamic> textMap,
      {String? otherName,
      String? otherIcon,
      String? groupId,
      String? groupName,
      String? groupIcon,
      String? friendId,
      String? msgId}) {
    chatType == "CHAT"
        ? sendMessage(friendId!, jsonEncode(textMap), otherName ?? "",
            otherIcon ?? "", "TEXT", msgId: msgId)
        : sendGroupMessage(
            groupId!, groupName!, groupIcon!, jsonEncode(textMap), "TEXT",
            msgId: msgId);
  }

  static sendImageMessage(String chatType, Map<String, dynamic> imageMap,
      {String? otherName,
      String? otherIcon,
      String? groupId,
      String? groupName,
      String? groupIcon,
      String? friendId,
      String? msgId}) {
    chatType == "CHAT"
        ? sendMessage(friendId!, jsonEncode(imageMap), otherName ?? "",
            otherIcon ?? "", "IMAGE", msgId: msgId)
        : sendGroupMessage(
            groupId!, groupName!, groupIcon!, jsonEncode(imageMap), "IMAGE",
            msgId: msgId);
  }

  static sendVideoMessage(String chatType, Map<String, dynamic> videoMap,
      {String? otherName,
      String? otherIcon,
      String? groupId,
      String? groupName,
      String? groupIcon,
      String? friendId,
      String? msgId}) {
    chatType == "CHAT"
        ? sendMessage(friendId!, jsonEncode(videoMap), otherName ?? "",
            otherIcon ?? "", "VIDEO", msgId: msgId)
        : sendGroupMessage(
            groupId!, groupName!, groupIcon!, jsonEncode(videoMap), "VIDEO",
            msgId: msgId);
  }

  static sendVoiceMessage(String chatType, Map<String, dynamic> voiceMap,
      {String? otherName,
      String? otherIcon,
      String? groupId,
      String? groupName,
      String? groupIcon,
      String? friendId,
      String? msgId}) {
    chatType == "CHAT"
        ? sendMessage(friendId!, jsonEncode(voiceMap), otherName ?? "",
            otherIcon ?? "", "VOICE", msgId: msgId)
        : sendGroupMessage(
            groupId!, groupName!, groupIcon!, jsonEncode(voiceMap), "VOICE",
            msgId: msgId);
  }

  static sendGeoMessage(String chatType, Map<String, dynamic> positionMap,
      {String? otherName,
      String? otherIcon,
      String? groupId,
      String? groupName,
      String? groupIcon,
      String? friendId,
      String? msgId}) {
    chatType == "CHAT"
        ? sendMessage(friendId!, jsonEncode(positionMap), otherName ?? "",
            otherIcon ?? "", "GEO", msgId: msgId)
        : sendGroupMessage(
            groupId!, groupName!, groupIcon!, jsonEncode(positionMap), "GEO",
            msgId: msgId);
  }

  static sendFileMessage(String chatType, Map<String, dynamic> fileMap,
      {String? otherName,
      String? otherIcon,
      String? groupId,
      String? groupName,
      String? groupIcon,
      String? friendId,
      String? msgId}) {
    chatType == "CHAT"
        ? sendMessage(friendId!, jsonEncode(fileMap), otherName ?? "",
            otherIcon ?? "", "FILE", msgId: msgId)
        : sendGroupMessage(
            groupId!, groupName!, groupIcon!, jsonEncode(fileMap), "FILE",
            msgId: msgId);
  }

  static sendCardMessage(String chatType, Map<String, dynamic> cardMap,
      {String? otherName,
      String? otherIcon,
      String? groupId,
      String? groupName,
      String? groupIcon,
      String? friendId,
      String? msgId}) {
    chatType == "CHAT"
        ? sendMessage(friendId!, jsonEncode(cardMap), otherName ?? "",
            otherIcon ?? "", "CARD", msgId: msgId)
        : sendGroupMessage(
            groupId!, groupName!, groupIcon!, jsonEncode(cardMap), "CARD",
            msgId: msgId);
  }

  static playSound() async {
    final player = AudioPlayer();
    player
        .setAsset("assets/sounds/message.mp3")
        .whenComplete(() => player.play());
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
      msg
        ..id = int.parse(serverId)
        ..progress = MSG_READ
        ..save();
    }
  }

  @override
  void onMessageSent(String localId, String serverId) {
    Message? msg = LocalStore.findCache(localId);
    if (msg != null) {
      msg
        ..id = int.parse(serverId)
        ..progress = MSG_SENT
        ..save();
    }

    Log.red("onMessageSent ${msg?.id}");
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
  void onNewMessage(Message? msg) {
    if (msg != null) {
      _centre.newMessageListener?.call(msg);
      Log.red("onNewMessage onNewMessage ${msg.toJson()}");
      msg..progress = MSG_RECEIVED;
      // 判断是否有群@
      if (msg.contentType == "TEXT") {
        // 将群@的编码解码
        var msgText = checkRemindMsg(convert.jsonDecode(msg.content)["text"]);
        // 如果有群提醒则判断是否提醒了自己
        if (msgText is List) {
          msg..content = convert.jsonEncode({"text": msgText[0]});
          Map<String, dynamic> temp = convert.jsonDecode(msgText[1]);
          var result = temp.values.firstWhere(
              (element) => element == UserCentre.getInfo()?.userID,
              orElse: () => "");
          // 如果提醒了自己则在session中标记
          if (result != "") {
            LocalStore.refreshSession(
                msg, msg.type == "CHAT" ? msg.sender : msg.groupID,
                sessionTime: msg.createTime, reminderMe: 1);
          }
        } else {
          LocalStore.refreshSession(
              msg, msg.type == "CHAT" ? msg.sender : msg.groupID,
              sessionTime: msg.createTime);
        }
      } else {
        LocalStore.refreshSession(
            msg, msg.type == "CHAT" ? msg.sender : msg.groupID,
            sessionTime: msg.createTime);
      }
      LocalStore.addMessage(msg);
      Session? temp = LocalStore.findSession(
          msg.type == "CHAT" ? msg.sender : msg.groupID!);
      if (temp?.mute != 1 && SettingCentre.settingConfigInfo?.mute != 1) {
        MessageCentre.playSound();
      }
      if (temp?.mute != 1 && SettingCentre.settingConfigInfo?.shock != 1) {
        Vibration.vibrate(duration: 100);
      }
      if (LocalStore.findSession(msg.type == "CHAT" ? msg.sender : msg.groupID!)
                  ?.notice !=
              1 &&
          SettingCentre.settingConfigInfo?.notice != 1) {}
    }
  }
}
