import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:hatchery_im/api/engine/entity.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/log.dart';
import 'package:hatchery_im/manager/messageCentre.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hatchery_im/manager/userCentre.dart';
import 'Adapters.dart';
import '../manager/MsgHelper.dart';

class LocalStore {
  static Box<Session>? sessionBox;
  static Box<Message>? messageBox;
  static bool _initDone = false;

  static init() async {
    String dbName = 'hive_db_' + UserCentre.getUserID();
    if (!_initDone) {
      _initDone = true;
      Log.log("LocalStore. init $dbName");

      /// 需要给一个名称，否则不能保存数据
      await Hive.initFlutter(dbName);
      Hive.registerAdapter(SessionAdapter());
      Hive.registerAdapter(MessageAdapter());
      sessionBox = await Hive.openBox<Session>('sessionBox');
      messageBox = await Hive.openBox<Message>('messageBox');
      Log.log("sessionBox.path ${sessionBox?.values.length} ");
      // sessionBox!.watch().listen((event) {
      //   Log.red(
      //       "DDAI Watcher.  key=${event.key} ; value=${event.value} ; deleted=${event.deleted}");
      // });
    }
  }

  Future getSessions() async {
    return sessionBox?.values;
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

  void createNewSession(
      {CSSendMessage? csSendMessage, CSSendGroupMessage? csSendGroupMessage}) {
    Log.yellow("createSession createSession. ${csSendMessage?.to} ");
    if (csSendMessage != null) {
      if (findSession(csSendMessage.to) != null) {
        return;
      }
    }
    if (csSendGroupMessage != null) {
      if (findSession(csSendGroupMessage.groupId) != null) {
        return;
      }
    }
    String? receiverNickName;
    String? receiverIcon;
    Map<String, dynamic> sessionMap = {
      "id": DateTime.now().millisecondsSinceEpoch,
      "title": csSendMessage != null
          ? receiverNickName ?? csSendMessage.to
          : csSendGroupMessage!.groupName,
      "icon": csSendMessage != null
          ? receiverIcon ?? ""
          : csSendGroupMessage!.groupIcon,
      "ownerID": csSendMessage?.from ?? csSendGroupMessage!.from,
      "otherID": csSendMessage?.to ?? csSendGroupMessage!.groupId,
      "type": csSendMessage != null ? 0 : 1,
      "updateTime": DateTime.now().millisecondsSinceEpoch,
      "lastChatMessage": null,
      "lastGroupChatMessage": null,
      "createTime": DateTime.now().millisecondsSinceEpoch
    };
    sessionMap[
        csSendMessage != null ? "lastChatMessage" : "lastGroupChatMessage"] = {
      "id": DateTime.now().millisecondsSinceEpoch,
      "userMsgID": csSendMessage?.msgId ?? csSendGroupMessage!.msgId,
      "sender": csSendMessage?.from ?? csSendGroupMessage!.from,
      "icon": csSendMessage?.icon ?? csSendGroupMessage!.icon,
      "nick": csSendMessage?.nick ?? csSendGroupMessage!.nick,
      "type": csSendMessage?.type ?? csSendGroupMessage!.type,
      "source": csSendMessage?.source ?? csSendGroupMessage!.source,
      "content": csSendMessage?.content ?? csSendGroupMessage!.content,
      "contentType":
          csSendMessage?.contentType ?? csSendGroupMessage!.contentType,
      "createTime": DateTime.now().millisecondsSinceEpoch
    };
    Session session = Session.fromJson(sessionMap);
    // sessionBox?.add(session);
    List<Session> allSession = sessionBox?.values.toList() ?? [];
    allSession.insert(0, session);
    saveSessions(allSession);
    if (csSendMessage != null) {
      API.getFriendInfo(csSendMessage.to).then((value) {
        if (value.isSuccess()) {
          FriendProfile friendProfile = FriendProfile.fromJson(value.getData());
          receiverNickName = friendProfile.nickName;
          receiverIcon = friendProfile.icon;
          findSession(friendProfile.friendId)
            ?..title = receiverNickName ?? ""
            ..icon = receiverIcon ?? ""
            ..save();
        }
      });
    }
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

  static closeHiveDB() {
    sessionBox!.close();
    messageBox!.close();
    return Hive.close();
  }

  static deleteSession(int sessionKey) {
    Log.yellow("deleteSession. deleteSession ");
    return sessionBox?.delete(sessionKey);
  }
}
