import 'package:hatchery_im/api/entity.dart';

class AppHandler {
  // get friends from DB
  //https://pub.dev/packages/sqflite_common_ffi
  static Future<List<Friends>> getFriends() async {
    //TODO db
    return [];
  }

  //save friends into DB
  static void saveFriends(List<Friends>? friendsList) async {}

  static Future<List<Session>> getSessions() async {
    return [];
  }

  static void saveSessions(List<Session>? sessions) {}
}
