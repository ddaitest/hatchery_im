import 'package:flutter/foundation.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/log.dart';
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
    }
  }

  Future<List<Session>> getSessions() async {
    return sessionBox?.values.toList() ?? [];
  }

  void saveSessions(List<Session>? sessions) {
    if (sessions != null) {
      sessionBox?.clear();
      sessionBox?.addAll(sessions);
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
    print("DEBUG=> GROUP addMessage ${msg.groupID}");
    cache[msg.userMsgID] = msg;
    messageBox?.add(msg);
    //update session
    if (msg.isGroup()) {
      findSession(msg.getOtherId() ?? "")
        ?..lastGroupChatMessage = msg
        ..save();
    } else {
      findSession(msg.getOtherId() ?? "")
        ?..lastChatMessage = msg
        ..save();
    }
  }

  static Message? findCache(String localId) {
    return cache[localId];
  }

  static ValueListenable<Box<Message>> listenMessage() {
    return Hive.box<Message>('messageBox').listenable();
  }
}
