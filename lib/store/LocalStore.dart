import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:hatchery_im/api/engine/entity.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/log.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/manager/messageCentre.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hatchery_im/manager/userCentre.dart';
import 'Adapters.dart';
import '../manager/MsgHelper.dart';

class LocalStore {
  static HiveInterface? hiveModel;
  static Box<Session>? sessionBox;
  static Box<Message>? messageBox;

  static init() {
    /// 多账号多db区分开
    String dbName = "hive_db_" + UserCentre.getUserID();
    if (hiveModel == null) {
      hiveModel = Hive;

      /// 需要给一个名称，否则不能保存数据
      hiveModel?.initFlutter(dbName).then((_) {
        Log.yellow("Hive initFlutter");

        /// 防止重复注册，即便Hive.close() 也不能取消注册，如果覆盖注册hive会有提示说可能有未知问题
        if (!hiveModel!.isAdapterRegistered(ADAPTER_SESSION))
          hiveModel?.registerAdapter(SessionAdapter());
        if (!hiveModel!.isAdapterRegistered(ADAPTER_MESSAGE))
          hiveModel?.registerAdapter(MessageAdapter());
        hiveModel
            ?.openBox<Session>('sessionBox')
            .then((value) => sessionBox = value);
        hiveModel
            ?.openBox<Message>('messageBox')
            .then((value) => messageBox = value);
      });
      return;

      // sessionBox!.watch().listen((event) {
      //   Log.red(
      //       "DDAI Watcher.  key=${event.key} ; value=${event.value} ; deleted=${event.deleted}");
      // });

    }
    return;
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

    /// 按消息更新时间排序，可能有简便的写法
    /// todo 置顶和普通分开按时间排序
    List<Session> allSession = sessionBox?.values.toList() ?? [];
    allSession.sort((a, b) => a.updateTime.compareTo(b.updateTime));
    sessionBox!.clear().then((_) => {sessionBox!.addAll(allSession)});
    sortSessionForTopChat();
  }

  static void createNewSession(
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
    sessionBox?.add(session);
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

  static void setChatTop({String? otherId, int chatTopType = 0}) {
    if (otherId != null) {
      Log.red("DEBUG=> setChatTop $otherId chatTopType $chatTopType");
      findSession(otherId)
        ?..top = chatTopType
        ..save();
      showToast("设置成功");
    } else {
      showToast("设置失败，请重试");
    }
    sortSessionForTopChat();
  }

  /// 置顶消息重新排序
  static void sortSessionForTopChat() {
    List<Session>? topChatSession = [];
    List<Session>? unTopChatSession = [];
    sessionBox?.values.forEach((Session session) {
      if (session.top == 1) {
        topChatSession.insert(0, session);
      } else {
        unTopChatSession.add(session);
      }
    });
    Log.yellow("topChatSession ${topChatSession.length}");
    Log.yellow("unTopChatSession ${unTopChatSession.length}");
    if (topChatSession.isNotEmpty) {
      Log.yellow("topChatSession.isNotEmpty");
      unTopChatSession.addAll(topChatSession);
      sessionBox!.clear().then((_) => {sessionBox!.addAll(unTopChatSession)});
      Log.yellow("sessionBox ${sessionBox?.length}");
    }
  }

  static Message? findCache(String localId) {
    return cache[localId];
  }

  static ValueListenable<Box<Message>> listenMessage() {
    return messageBox!.listenable();
  }

  static ValueListenable<Box<Session>> listenSessions() {
    return sessionBox!.listenable();
  }

  static closeHiveDB() {
    sessionBox!.close();
    messageBox!.close();
    hiveModel?.close();
    hiveModel = null;
    Log.yellow("closeHiveDB done ");
  }

  static deleteSession(int sessionKey) {
    Log.yellow("deleteSession. deleteSession ");
    return sessionBox?.delete(sessionKey);
  }
}
