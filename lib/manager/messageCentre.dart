import 'dart:convert';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/cupertino.dart';
import 'package:hatchery_im/api/API.dart';
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
    centre._initSessions();
    LocalStore.init();
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
    engine?.init('ws://149.129.176.107:5889/ws', _userInfo?.userID ?? "",
        source: TARGET_PLATFORM);
    engine?.connect();
    engine?.setCallback(MyEngineHandler(centre));
    Log.yellow("MessageCentre.init() - finish");
    sendAuth();
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
  _initSessions() async {
    Log.yellow("_initSessions 开始");
    // Step1. 返回本地存储的数据。
    sessions = await _localStore.getSessions();
    Log.yellow("_initSessions Step1. 返回本地存储的数据 $sessions");
    sessionListener?.call(sessions ?? []);
    // Step2. 从Server获取最新数据。
    API.querySession().then((value) {
      if (value.isSuccess()) {
        var news = value.getDataList((m) => Session.fromJson(m));
        Log.yellow("_initSessions Step1. 从Server获取最新数据。 $news");
        // Step3. 刷新本地数据。
        _localStore.saveSessions(news);
        _syncNewSessions(news);
        sessions = news;
        sessionListener?.call(sessions ?? []);
        Log.yellow("_initSessions 从Server获取最新数据");
      }
    });
  }

  ///找出需要同步的session
  _syncNewSessions(List<Session> news) {
    List<Session> before = new List.from(sessions ?? []);
    news.forEach((newOne) {
      int index = before.indexWhere((oldOne) => oldOne.id == newOne.id);
      if (index < 0) {
        _syncSession(null, newOne);
      } else {
        _syncSession(before[index], newOne);
      }
    });
  }

  ///同步 session 的 message
  _syncSession(Session? before, Session latest) {
    if (latest.type == CHAT_TYPE_ONE) {
      //单聊
      if (before == null) {
        //更新消息,一直到没有
        _loadFriendHistory(latest.otherID, latest.lastChatMessage.id, -1);
      } else if (before.lastChatMessage.id != latest.lastChatMessage.id) {
        //更新消息,一直到before
        _loadFriendHistory(latest.otherID, latest.lastChatMessage.id,
            before.lastChatMessage.id);
      }
    } else {
      //群聊
      if (before == null) {
        //更新消息,一直到没有
        _loadGroupHistory(latest.otherID, latest.lastGroupChatMessage.id, -1);
      } else if (before.lastGroupChatMessage.id !=
          latest.lastGroupChatMessage.id) {
        //更新消息,一直到before
        _loadGroupHistory(latest.otherID, latest.lastGroupChatMessage.id,
            before.lastGroupChatMessage.id);
      }
    }
  }

  _loadFriendHistory(String friendID, int from, int to) async {
    Log.yellow("更新消息, 单聊, $from to $to");
    int currentFrom = from;
    bool found = false;
    bool end = false;
    while (!found && !end) {
      var result = await _queryHistoryFriend(friendID, currentFrom);
      end = result.length < 1;
      var temp = <Message>[];
      for (var msg in result) {
        if (msg.id == to) {
          found = true;
          break;
        } else {
          currentFrom = msg.id;
          LocalStore.addMessage(msg);
          temp.add(msg);
        }
      }
      if (temp.length > 0) {
        //Notify all
        _notifyMessageChanged(friendID);
      }
    }
  }

  _loadGroupHistory(String friendID, int from, int to) async {
    Log.yellow("更新消息, 群聊, $from to $to");
    //TODO
  }

  Future<List<Message>> _queryHistoryFriend(String friendID, int from) async {
    var values = await API.messageHistoryWithFriend(
        friendID: friendID, currentMsgID: from, page: 0, size: LOAD_SIZE);
    var news = values.getDataList((m) => Message.fromJson(m));
    return news;
  }

  Future<List<Message>> _queryHistoryGroup(String groupID, int from) async {
    var values = await API.getGroupHistory(
        groupID: groupID, currentMsgID: from, page: 0, size: LOAD_SIZE);
    var news = values.getDataList((m) => Message.fromJson(m));
    return news;
  }

  _notifyMessageChanged(String friendID) {}

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
  sendMessage(String to, Map<String, dynamic> content, String contentType) {
    CSSendMessage msg = Protocols.sendMessage(
        _userInfo?.userID ?? "",
        _userInfo!.nickName!,
        to,
        _userInfo!.icon!,
        TARGET_PLATFORM,
        content,
        contentType);
    engine?.sendProtocol(msg.toJson());
    Message message = ModelHelper.convertMessage(msg);
    message.progress = MSG_SENDING;
    LocalStore.addMessage(message);
  }

  sendGroupMessage(String groupId, String groupName,
      Map<String, dynamic> content, String contentType) {
    CSSendGroupMessage msg = Protocols.sendGroupMessage(
        _userInfo?.userID ?? "",
        _userInfo!.nickName!,
        groupId,
        groupName,
        _userInfo!.icon!,
        TARGET_PLATFORM,
        content,
        contentType);
    engine?.sendProtocol(msg.toJson());
    Message message = ModelHelper.convertGroupMessage(msg);
    message.progress = MSG_SENDING;
    LocalStore.addMessage(message);
  }

  static sendTextMessage(String to, String text) {
    _singleton.sendMessage(to, {"text": text}, "TEXT");
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
      msg.progress = MSG_READ;
      msg.save();
    }
  }

  @override
  void onMessageSent(String localId, String serverId) {
    Message? msg = LocalStore.findCache(localId);
    if (msg != null) {
      msg.progress = MSG_SENT;
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
    LocalStore.addMessage(msg);
  }
}
