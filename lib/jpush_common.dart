import 'package:jpush_flutter/jpush_flutter.dart';

import 'common/log.dart';

class JpushPlugin {
  static void initPush() {
    JPush().addEventHandler(
      onReceiveNotification: (Map message) async {
        Log.green("flutter onReceiveNotification: $message");
      },
      onOpenNotification: (Map message) async {
        Log.green("flutter onOpenNotification: $message");
      },
      onReceiveMessage: (Map message) async {
        Log.green("flutter onReceiveMessage: $message");
      },
    );

    JPush().applyPushAuthority(
      NotificationSettingsIOS(sound: true, alert: true, badge: true),
    );

    JPush().setup(
      appKey: "9d8b80bc783241abdf1f8ae0",
      channel: "developer-default",
      production: false,
      debug: false,
    );
  }

  /// 登录设置tag

  static void setTags(List<String> tags) {
    JPush().setTags(tags);
  }

  /// 退出清空tag

  static void cleanTags() {
    JPush().cleanTags();
  }

  /// 清空角标

  static void setBadge({int badgeCount = 0}) {
    JPush().setBadge(badgeCount);
  }
}
