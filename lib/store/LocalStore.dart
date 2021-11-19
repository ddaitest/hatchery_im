import 'package:flutter/foundation.dart';
import 'package:hatchery_im/api/engine/entity.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/log.dart';
import 'package:hatchery_im/manager/messageCentre.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'Adapters.dart';
import '../manager/MsgHelper.dart';

class LocalStore {
  static Box<Session>? sessionBox;
  static Box<Message>? messageBox;
  static bool initDone = false;

  static init() async {
    if (!initDone) {
      Log.log("LocalStore. init ");
      initDone = true;
      await Hive.initFlutter();
      Hive.registerAdapter(SessionAdapter());
      Hive.registerAdapter(MessageAdapter());
      sessionBox = await Hive.openBox<Session>('sessionBox');
      messageBox = await Hive.openBox<Message>('messageBox');
      // sessionBox!.watch().listen((event) {
      //   Log.red(
      //       "DDAI Watcher.  key=${event.key} ; value=${event.value} ; deleted=${event.deleted}");
      // });
    }
  }

  Future<List<Session>> getSessions() async {
    return sessionBox?.values.toList() ?? [];
  }

  void saveSessions(List<Session>? sessions) {
    if (sessions != null) {
      Log.yellow("saveSessions. ${sessions.length} ");
      sessionBox!.clear().then((_) => {sessionBox!.addAll(sessions)});
    }
  }

  static Session? findSession(String friendId) {
    Session? result;
    try {
      result = sessionBox?.values
          .firstWhere((element) => element.otherID == friendId);
    } catch (e) {}
    return result;
  }

  static Map<String, Message> cache = Map();

  static void addMessage(Message msg) {
    cache[msg.userMsgID] = msg;
    messageBox?.add(msg);
    // sessionBox?.add(msg);
    //update session
    if (msg.isGroup()) {
      print("DEBUG=> isGroup isGroup ${msg.toJson()}");
      findSession(msg.groupID ?? "")
        ?..lastGroupChatMessage = msg
        ..updateTime = msg.createTime
        ..save();
    } else {
      print("DEBUG=> isChat isChat ${msg.toJson()}");
      findSession(msg.getOtherId() ?? "")
        ?..lastChatMessage = msg
        ..updateTime = msg.createTime
        ..save();
    }
  }

  static createSession(
      {CSSendMessage? csSendMessage, CSSendGroupMessage? csSendGroupMessage}) {
    Map<String, dynamic> sessionMap = {
      "id": 0,
      "title": csSendMessage != null
          ? csSendMessage.nick
          : csSendGroupMessage!.groupName,
      "icon": csSendMessage != null
          ? csSendMessage.icon
          : csSendGroupMessage!.groupIcon,
      "ownerID":
          csSendMessage != null ? csSendMessage.from : csSendGroupMessage!.from,
      "otherID": csSendMessage != null
          ? csSendMessage.to
          : csSendGroupMessage!.groupId,
      "type": csSendMessage != null ? 0 : 1,
      "updateTime": DateTime.now().millisecondsSinceEpoch,
      "lastChatMessage": null,
      "lastGroupChatMessage": null,
      "createTime": 0
    };

    /// todo
    if (csSendMessage != null) {
      sessionMap["lastChatMessage"] = {
        "id": 0,
        "userMsgID": csSendMessage.msgId,
        "sender": csSendMessage.from,
        "icon": csSendMessage.icon,
        "nick": csSendMessage.nick,
        "type": csSendMessage.type,
        "source": csSendMessage.source,
        "content": csSendMessage.content,
        "contentType": csSendMessage.contentType,
        "createTime": 0
      };
    }
    if (csSendGroupMessage != null) {
      sessionMap["lastGroupChatMessage"] = {
        "id": 0,
        "userMsgID": csSendGroupMessage.msgId,
        "sender": csSendGroupMessage.from,
        "icon": csSendGroupMessage.icon,
        "nick": csSendGroupMessage.nick,
        "type": csSendGroupMessage.type,
        "source": csSendGroupMessage.source,
        "content": csSendGroupMessage.content,
        "contentType": csSendGroupMessage.contentType,
        "createTime": 0
      };
    }
    Session session = Session.fromJson(sessionMap);
    sessionBox!.add(session);
    Log.yellow("makeSession. ${sessionBox?.length} ");
  }

  static Message? findCache(String localId) {
    return cache[localId];
  }

  static ValueListenable<Box<Message>> listenMessage() {
    return Hive.box<Message>('messageBox').listenable();
  }

  static Box<Session> listenSessions() {
    return Hive.box<Session>('sessionBox');
  }

  static void deleteSession(String friendId) {
    Log.yellow("deleteSession. deleteSession ");
    findSession(friendId)
      ?..otherID = friendId
      ..delete();
  }
}
