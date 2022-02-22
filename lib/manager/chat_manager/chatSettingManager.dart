import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/store/LocalStore.dart';

class ChatSettingManager extends ChangeNotifier {
  bool isTop = false;
  bool isMute = false;

  /// 初始化
  init(String? otherId, String? chatType) {
    if (otherId != null) {
      Session? session = LocalStore.findSession(otherId);
      if (session != null) {
        int topStatus = session.top ?? 0;
        int muteStatus = session.mute ?? 0;
        topStatus == 0 ? isTop = false : isTop = true;
        muteStatus == 0 ? isMute = false : isMute = true;
      }
    }
  }

  void setTopMsgSwitch(String otherId, bool switchValue) {
    LocalStore.setChatTop(otherId: otherId, chatTopType: switchValue ? 1 : 0)
        .then((bool value) {
      if (value) {
        isTop = switchValue;
        notifyListeners();
      }
    });
  }

  void setMuteMsgSwitch(String otherId, bool switchValue) {
    LocalStore.setChatMute(otherId: otherId, chatMuteType: switchValue ? 1 : 0)
        .then((bool value) {
      if (value) {
        isMute = switchValue;
        notifyListeners();
      }
    });
  }

  // /// 删除此otherId的本地聊天记录
  // Future<void> deleteMsgHistory(String? otherId) async {
  //   if (otherId != null || otherId != "") {
  //     List<Message> msgList = [];
  //     MessageCentre.getMessages(otherId: otherId)
  //         .then((value) => msgList = value);
  //     if (msgList.isNotEmpty) {
  //       msgList.forEach((element) {
  //         element.delete();
  //       });
  //     }
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
  }
}
