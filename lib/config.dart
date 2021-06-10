import 'package:flutter/material.dart';

const bool TEST = true;

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
  static final int SPLASH_TIMEOUT = TEST ? 3 : 5;
  static final int POP_AD_WAIT_TIME = TEST ? 1 : 5;
  static final int UPGRADE_SHOW_DELAY = TEST ? 5 : 10;
  static final int UPGRADE_WAIT_DAY = TEST ? 3 : 3;
  static final int DEFAULT_SHOW_POP_TIMES = TEST ? 5 : 1;
  static final int BACKGROUND_SPLASH_WAIT_TIME = TEST ? 3 : 60;
}

const mainTabs = [
  TabInfo(Icons.messenger_outline, Icons.messenger),
  TabInfo(Icons.account_circle_outlined, Icons.account_circle),
  TabInfo(Icons.group_outlined, Icons.group),
  TabInfo(Icons.perm_identity, Icons.person),
];

class TabInfo {
  final String? label;
  final IconData icon;
  final IconData activeIcon;

  const TabInfo(this.icon, this.activeIcon, {this.label});
}
