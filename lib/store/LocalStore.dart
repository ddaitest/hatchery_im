import 'package:flutter/foundation.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/log.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/manager/messageCentre.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hatchery_im/manager/userCentre.dart';
import 'Adapters.dart';
import '../manager/MsgHelper.dart';

class LocalStore {
  static Box<Session>? sessionBox;
  static Box<Message>? messageBox;

  static init() {
    /// 多账号多db区分开
    String dbName = "hive_db_" + UserCentre.getUserID();

    /// 需要给一个名称，否则不能保存数据
    Log.yellow("Hive initFlutter");
    Hive.initFlutter(dbName).whenComplete(() async {
      /// 防止重复注册，即便Hive.close() 也不能取消注册，如果覆盖注册hive会有提示说可能有未知问题
      if (!Hive.isAdapterRegistered(ADAPTER_SESSION))
        Hive.registerAdapter(SessionAdapter());
      if (!Hive.isAdapterRegistered(ADAPTER_MESSAGE))
        Hive.registerAdapter(MessageAdapter());
      Log.yellow("openBox messageBox");
      messageBox = await Hive.openBox<Message>('messageBox');
      Log.yellow("openBox sessionBox");
      sessionBox = await Hive.openBox<Session>('sessionBox');
    });
  }

  static Future<List<Session>> getSessions() async {
    return sessionBox?.values.toList() ?? [];
  }

  void saveSessions(List<Session>? sessions) {
    if (sessions != null) {
      Log.yellow("saveSessions. ${sessions.length} ");
      sessionBox!.clear().then((_) => {sessionBox!.addAll(sessions)});
    }
  }

  static Session? findSession(String otherId) {
    Session? result;
    try {
      result = sessionBox?.values
          .firstWhere((element) => element.otherID == otherId);
    } catch (e) {}
    return result;
  }

  static Iterable<Message>? findMessage(String otherId) {
    Iterable<Message>? result;
    try {
      result = messageBox?.values
          .where((element) => element.getOtherId() == otherId);
    } catch (e) {}
    return result;
  }

  static Map<String, Message> cache = Map();

  static void addMessage(Message msg) {
    cache[msg.userMsgID] = msg;
    messageBox?.add(msg);
  }

  /// 刷新session，尽量传sessionTime
  static Future<void> refreshSession(Message? message, String? otherId,
      {int? sessionTime}) async {
    if (otherId != null && message != null) {
      var info;

      ApiResult values = message.type == "CHAT"
          ? await API.getUsersInfo(otherId)
          : await API.getGroupInfo(otherId);
      if (values.isSuccess()) {
        info = message.type == "CHAT"
            ? UsersInfo.fromJson(values.getData())
            : GroupInfo.fromJson(values.getData()['group']);
        Session? result = findSession(otherId);
        int unReadCount = getUnReadMessageCount(otherId: otherId);
        if (result != null) {
          message.isGroup()
              ? result.lastGroupChatMessage = message
              : result.lastChatMessage = message;
          if (unReadCount > 0) result.unReadCount = unReadCount;
          result
            ..title = message.type == "CHAT"
                ? info.nickName ?? result.title
                : info.groupName ?? result.title
            ..icon = info.icon ?? result.icon
            ..updateTime = sessionTime ?? DateTime.now().millisecondsSinceEpoch
            ..save();
        } else {
          createNewSession(
              chatType: message.isGroup() ? "GROUP" : "CHAT",
              message: message,
              sessionOtherId: otherId,
              sessionOwnerId: UserCentre.getUserID(),
              sessionTitle: message.type == "CHAT"
                  ? info.nickName ?? "昵称"
                  : info.groupName ?? "群名称",
              sessionIcon: info.icon ?? "",
              sessionTime: sessionTime,
              unRead: unReadCount > 0 ? unReadCount : 0);
        }
        sortSession();
      }
    }
  }

  /// 创建session
  static void createNewSession(
      {String? chatType,
      Message? message,
      String sessionOtherId = "",
      String sessionOwnerId = "",
      String sessionTitle = "",
      String sessionIcon = "",
      int? sessionTime,
      int unRead = 0}) {
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
          sessionTime ?? DateTime.now().millisecondsSinceEpoch,
          0,
          unRead,
          0,
          0,
          0,
          0);
      sessionBox?.add(session);
    }
  }

  /// 设置首页session置顶，设置成功后重新排序session
  static Future<bool> setChatTop({String? otherId, int chatTopType = 0}) async {
    if (otherId != null && otherId != "") {
      findSession(otherId)
        ?..top = chatTopType
        ..save();
      showToast("设置成功");
      sortSession();
      return true;
    } else {
      showToast("设置失败，请重试");
      return false;
    }
  }

  static Future<bool> setChatMute(
      {String? otherId, int chatMuteType = 0}) async {
    if (otherId != null && otherId != "") {
      findSession(otherId)
        ?..mute = chatMuteType
        ..shock = chatMuteType
        ..notice = chatMuteType
        ..save();
      showToast("设置成功");
      return true;
    } else {
      showToast("设置失败，请重试");
      return false;
    }
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
      /// 按消息更新时间排序，置顶和普通分别排序，可能有简单的写法
      topChatSession.sort((a, b) => a.updateTime.compareTo(b.updateTime));
      unTopChatSession.sort((a, b) => a.updateTime.compareTo(b.updateTime));

      /// 合并置顶和普通消息
      unTopChatSession.addAll(topChatSession);
      sessionBox?.clear().then((_) => {sessionBox?.addAll(unTopChatSession)});
      // sessionBox?.values.forEach((element) {
      //   Log.yellow("sessionBox ${element.top} ${element.title}");
      // });
    } else {
      List<Session> allSession = sessionBox?.values.toList() ?? [];
      allSession.sort((a, b) => a.updateTime.compareTo(b.updateTime));
      sessionBox?.clear().then((_) => {sessionBox?.addAll(allSession)});
    }
  }

  /// 获取消息未读数，来源：Message.progress = MSG_RECEIVED
  static int getUnReadMessageCount({String? otherId}) {
    int count = 0;
    List<Message> temp = [];
    temp = MessageCentre.getMessages();
    count = temp
        .where((element) => element.type == "CHAT"
            ? element.sender == otherId &&
                element.receiver == UserCentre.getUserID() &&
                element.progress == MSG_RECEIVED
            : element.groupID == otherId && element.progress == MSG_RECEIVED)
        .length;
    Log.green("getUnReadMessageCount ${count.toString()} ${temp.length}");
    return count >= 0 ? count : 0;
  }

  static Message? findCache(String localId) {
    return cache[localId];
  }

  static ValueListenable<Box<Message>> listenMessage() {
    return messageBox!.listenable();
  }

  static ValueListenable<Box<Message>> removeListenMessage() {
    return messageBox!.listenable();
  }

  static ValueListenable<Box<Session>> listenSessions() {
    return sessionBox!.listenable();
  }

  static closeHiveDB() {
    sessionBox!.close();
    messageBox!.close();
    Hive.close();
    MessageCentre.engine?.disconnect();
    Log.yellow("closeHiveDB done ");
  }

  static deleteSession(int sessionKey) {
    Log.yellow("deleteSession. deleteSession ");
    return sessionBox?.delete(sessionKey);
  }
}
