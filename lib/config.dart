import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'manager/devicesInfoCentre.dart';

bool debugMode = kDebugMode;

String TARGET_PLATFORM = DeviceInfo.platformName; //IOS/ANDROID/WINDOWS/MAC

class SPKey {
  static const String USERINFO = 'userInfo';
  static const String CONFIG = 'config';
  static const String SETTING_CONFIG = 'setting_config';
  static const String COMMON_PARAM_KEY = 'commonParamKey';
  static const String USER_ID_KEY = 'USER_ID_KEY';
}

class TimeConfig {
  static final int OTP_CODE_RESEND = debugMode ? 10 : 60;
}

const mainTabs = [
  TabInfo(Icons.messenger_outline, Icons.message, 0),
  TabInfo(Icons.account_circle_outlined, Icons.account_circle, 1),
  TabInfo(Icons.group_outlined, Icons.group, 2),
  TabInfo(Icons.person_outline, Icons.person, 3),
];

class TabInfo {
  final String? label;
  final IconData icon;
  final IconData activeIcon;
  final int index;

  const TabInfo(this.icon, this.activeIcon, this.index, {this.label});
}

class SlideActionInfo {
  final String? label;
  final IconData icon;
  final Color backgroundColor;
  final SlidableActionCallback? onPressed;

  const SlideActionInfo(this.label, this.icon, this.backgroundColor,
      {this.onPressed});
}

class ItemModel {
  String title;
  IconData icon;
  ItemModel(this.title, this.icon);
}

enum MessageBelongType {
  Sender,
  Receiver,
}

enum SelectContactsType {
  CreateGroup,
  AddGroupMember,
  DeleteGroupMember,
  Share,
}

enum QRCodeScanOriginType {
  Camera,
  LongTap,
}

enum addFriendOriginType {
  Normal,
  QRCode,
  ShareCard,
}

enum MapOriginType {
  Share,
  Send,
}

enum VideoLoadType {
  None,
  Loading,
  Fail,
  Done,
}
