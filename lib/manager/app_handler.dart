import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/api/model.dart';

class AppHandler {
  // get friends from DB
  static Future<List<Friends>> getFriends() async {
    //TODO db
    return [];
  }

  //save friends into DB
  static void saveFriends(List<Friends> friendsList) async {

  }

  static Future<List<Session>> getSessions() async {

    return [];
  }
}
