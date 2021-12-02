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
    print("DEBUG=> addMessage ${msg.toJson()}");
    Session? result =
        findSession(msg.isGroup() ? msg.groupID ?? "" : msg.receiver ?? "");
    if (result != null) {
      msg.isGroup()
          ? result.lastGroupChatMessage = msg
          : result.lastChatMessage = msg;
      result
        ..updateTime = msg.createTime
        ..save();
    } else {
      createNewSession(
          chatType: msg.isGroup() ? "GROUP" : "CHAT", message: msg);
    }
  }

  static void createNewSession({String? chatType, Message? message}) {
    String? sessionNickName;
    String? sessionIcon;
    if (message != null) {
      Map<String, dynamic> sessionMap = {
        "id": message.id,
        "title": chatType == "CHAT" ? "用户" : "群组",
        "icon": "",
        "ownerID": message.sender,
        "otherID": chatType == "CHAT" ? message.receiver : message.groupID,
        "type": chatType == "CHAT" ? 0 : 1,
        "updateTime": message.createTime,
        "lastChatMessage": null,
        "lastGroupChatMessage": null,
        "createTime": DateTime.now().millisecondsSinceEpoch
      };
      sessionMap[
          chatType == "CHAT" ? "lastChatMessage" : "lastGroupChatMessage"] = {
        "id": message.id,
        "userMsgID": message.userMsgID,
        "sender": message.sender,
        "icon": "",
        "nick": "",
        "type": message.type,
        "source": message.source,
        "content": message.content,
        "contentType": message.contentType,
        "createTime": message.createTime
      };
      Session session = Session.fromJson(sessionMap);
      sessionBox?.add(session);
      sortSession();
      if (chatType == "CHAT") {
        API.getUsersInfo(message.receiver ?? "").then((value) {
          if (value.isSuccess()) {
            UsersInfo usersInfo = UsersInfo.fromJson(value.getData());
            sessionNickName = usersInfo.nickName;
            sessionIcon = usersInfo.icon;
            findSession(message.receiver ?? "")
              ?..title = sessionNickName ?? ""
              ..icon = sessionIcon ?? ""
              ..save();
          }
          Log.yellow("getUsersInfo. $sessionNickName $sessionIcon ");
        });
      } else {
        API.getGroupInfo(message.groupID ?? "").then((value) {
          if (value.isSuccess()) {
            GroupInfo groupInfo = GroupInfo.fromJson(value.getData());
            sessionNickName = groupInfo.groupName;
            sessionIcon = groupInfo.icon;
            findSession(message.groupID ?? "")
              ?..title = sessionNickName ?? ""
              ..icon = sessionIcon ?? ""
              ..save();
          }
        });
      }
    }
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
    sortSession();
  }

  /// 置顶消息重新排序
  static void sortSession() {
    /// 把置顶的session分离开
    List<Session>? topChatSession = [];
    List<Session>? unTopChatSession = [];
    sessionBox?.values.forEach((Session session) {
      if (session.top == 1) {
        topChatSession.insert(0, session);
      } else {
        unTopChatSession.add(session);
      }
    });
    if (topChatSession.isNotEmpty) {
      /// 按消息更新时间排序，置顶和普通分别排序，可能有简便的写法
      topChatSession.sort((a, b) => a.updateTime.compareTo(b.updateTime));
      unTopChatSession.sort((a, b) => a.updateTime.compareTo(b.updateTime));

      /// 合并置顶和普通消息
      unTopChatSession.addAll(topChatSession);
      sessionBox!.clear().then((_) => {sessionBox!.addAll(unTopChatSession)});
      Log.yellow("sessionBox ${sessionBox?.length}");
    } else {
      List<Session> allSession = sessionBox?.values.toList() ?? [];
      allSession.sort((a, b) => a.updateTime.compareTo(b.updateTime));
      sessionBox!.clear().then((_) => {sessionBox!.addAll(allSession)});
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
