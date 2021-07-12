import 'package:hatchery_im/api/entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'Adapters.dart';

class LocalStore {
  static Box<Session>? sessionBox;
  static Box<Message>? messageBox;

  static init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(SessionAdapter());
    Hive.registerAdapter(MessageAdapter());
    sessionBox = await Hive.openBox<Session>('sessionBox');
    messageBox = await Hive.openBox<Message>('messageBox');
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

  Session? findSession(String friendId) {
    Session? result;
    try {
      result = sessionBox?.values
          .firstWhere((element) => element.otherID == friendId);
    } catch (e) {}
    return result;
  }

  void saveMessage(Message msg) {
    //TODO save msg
  }
}
