import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

bool debugMode = kDebugMode;

class SPKey {
  static final String showAgreement = 'ShowAgreement';
  static final String splashAD = 'splashAD';
  static final String userInfo = 'userInfo';
  static final String config = 'config';
  static final String CONFIG_KEY = 'configKey';
  static final String upgrade = 'upgrade';

  // static final String POP_AD_SHOW_TIMES_KEY = 'popShowTimesKey';
  static final String COMMON_PARAM_KEY = 'commonParamKey';
  static final String USER_ID_KEY = 'USER_ID_KEY';
}

class TimeConfig {
  static final int SPLASH_TIMEOUT = debugMode ? 3 : 5;
  static final int OTP_CODE_RESEND = debugMode ? 10 : 60;
  static final int UPGRADE_SHOW_DELAY = debugMode ? 5 : 10;
  static final int UPGRADE_WAIT_DAY = debugMode ? 3 : 3;
  static final int DEFAULT_SHOW_POP_TIMES = debugMode ? 5 : 1;
  static final int BACKGROUND_SPLASH_WAIT_TIME = debugMode ? 3 : 60;
}

const mainTabs = [
  TabInfo(Icons.messenger_outline, Icons.messenger, 0),
  TabInfo(Icons.account_circle_outlined, Icons.account_circle, 1),
  // Column(
  //   mainAxisSize: MainAxisSize.min,
  //   children: <Widget>[
  //     Icon(
  //       Icons.home,
  //       color: Colors.transparent,
  //     ),
  //     Text("发布", style: TextStyle(color: Color(0xFFEEEEEE)))
  //   ],
  // ),
  TabInfo(Icons.group_outlined, Icons.group, 2),
  TabInfo(Icons.perm_identity, Icons.person, 3),
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
  final Color iconColor;
  final Function? onTap;

  const SlideActionInfo(this.label, this.icon, this.iconColor, {this.onTap});
}

enum SelectContactsType {
  Group,
  Share,
}
