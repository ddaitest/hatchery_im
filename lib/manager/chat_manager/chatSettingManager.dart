import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/store/LocalStore.dart';

class ChatSettingManager extends ChangeNotifier {
  bool _isTop = false;
  bool _isMute = false;
  bool get isTop => _isTop;
  bool get isMute => _isMute;

  /// 初始化
  void init(String? otherId, String? chatType) {
    if (otherId != null) {
      Session? session = LocalStore.findSession(otherId);
      if (session != null) {
        int topStatus = session.top ?? 0;
        int muteStatus = session.mute ?? 0;
        _isTop = topStatus == 0 ? false : true;
        _isMute = muteStatus == 0 ? false : true;
      }
    }
  }

  void setTopMsgSwitch(String otherId, bool switchValue) {
    LocalStore.setChatTop(otherId: otherId, chatTopType: switchValue ? 1 : 0)
        .then((bool value) {
      if (value) {
        _isTop = switchValue;
        notifyListeners();
      }
    });
  }

  void setMuteMsgSwitch(String otherId, bool switchValue) {
    LocalStore.setChatMute(otherId: otherId, chatMuteType: switchValue ? 1 : 0)
        .then((bool value) {
      if (value) {
        _isMute = switchValue;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
