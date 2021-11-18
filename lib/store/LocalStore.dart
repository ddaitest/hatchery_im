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
      if (findSession(msg.groupID ?? "") != null) {
        findSession(msg.groupID ?? "")
          ?..lastGroupChatMessage = msg
          ..updateTime = msg.createTime
          ..save();
      } else {
        MessageCentre().initSessions();
      }
    } else {
      print("DEBUG=> isChat isChat ${msg.toJson()}");
      if (findSession(msg.getOtherId() ?? "") != null) {
        findSession(msg.getOtherId() ?? "")
          ?..lastChatMessage = msg
          ..updateTime = msg.createTime
          ..save();
      } else {
        MessageCentre().initSessions();
      }
    }
  }

  static makeSession(
      {CSSendMessage? csSendMessage, CSSendGroupMessage? csSendGroupMessage}) {
    Map<String, dynamic> sessionMap = {
      "title": csSendMessage != null
          ? csSendMessage.nick
          : csSendGroupMessage!.groupName,
      "otherID": csSendMessage != null
          ? csSendMessage.to
          : csSendGroupMessage!.groupId,
      "type": csSendMessage != null ? 0 : 1,
      "lastChatMessage": null,
      "lastGroupChatMessage": null
    };

    /// todo
    if (csSendMessage != null) {
      sessionMap["lastChatMessage"] = {
        "nick": csSendMessage.nick,
      };
    }
    if (csSendGroupMessage != null) {
      sessionMap["lastGroupChatMessage"] = {
        "nick": csSendGroupMessage.nick,
      };
    }
    Session session = Session.fromJson(sessionMap);
    sessionBox!.add(session);
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
