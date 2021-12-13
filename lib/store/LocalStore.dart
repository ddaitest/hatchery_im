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
        // messageBox!.watch().listen((event) {
        //   Log.red(
        //       "DDAI Watcher.  key=${event.key} ; value=${event.value} ; deleted=${event.deleted}");
        // });
      });
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

  static void addMessage(Message msg,
      {String? otherId,
      String? ownerId,
      String? sessionName,
      String? sessionImage}) {
    cache[msg.userMsgID] = msg;
    messageBox?.add(msg);
    //update session

    Session? result = findSession(otherId ?? "");
    if (result != null) {
      print("DEBUG=> addMessage addMessage $otherId");
      msg.isGroup()
          ? result.lastGroupChatMessage = msg
          : result.lastChatMessage = msg;
      if (sessionName != null || sessionName != "") {
        result.title = sessionName!;
      }
      if (sessionImage != null || sessionImage != "") {
        result.icon = sessionImage!;
      }
      result
        ..updateTime = msg.createTime
        ..save();
    } else {
      createNewSession(
          chatType: msg.isGroup() ? "GROUP" : "CHAT",
          message: msg,
          sessionOtherId: otherId ?? "",
          sessionOwnerId: ownerId ?? "",
          sessionTitle: sessionName ?? "",
          sessionIcon: sessionImage ?? "");
    }
    sortSession();
  }

  static void createNewSession(
      {String? chatType,
      Message? message,
      String sessionOtherId = "",
      String sessionOwnerId = "",
      String sessionTitle = "",
      String sessionIcon = ""}) {
    if (message != null) {
      Session session = Session(
          message.id,
          sessionTitle,
          chatType == "CHAT" ? 0 : 1,
          sessionIcon,
          sessionOwnerId,
          sessionOtherId,
          chatType == "CHAT" ? message : null,
          chatType == "GROUP" ? message : null,
          message.createTime,
          DateTime.now().millisecondsSinceEpoch,
          0);
      sessionBox?.add(session);
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
      sessionBox?.values.forEach((element) {
        Log.yellow("sessionBox ${element.top} ${element.title}");
      });
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
