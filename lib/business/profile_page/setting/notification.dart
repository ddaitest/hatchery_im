import 'package:flutter/material.dart';
import 'package:hatchery_im/manager/chat_manager/chatSettingManager.dart';
import 'package:hatchery_im/manager/profile_manager/setting_manager/settingManager.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/flavors/Flavors.dart';

class NotificationSettingPage extends StatelessWidget {
  final manager = App.manager<SettingManager>();

  @override
  Widget build(BuildContext context) {
    manager.init();
    return Scaffold(
        appBar: AppBarFactory.backButton(''),
        body: Container(
          padding: const EdgeInsets.only(left: 12.0, top: 12.0, right: 12.0),
          child: _listInfo(),
        ));
  }

  Widget _listInfo() {
    return ListView(
      shrinkWrap: true,
      children: [_muteSet(), _shockSet(), _noticeSet()],
    );
  }

  Widget _muteSet() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      color: Flavors.colorInfo.mainBackGroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text('声音'), _switchMuteView()],
      ),
    );
  }

  Widget _switchMuteView() {
    return Selector<SettingManager, int>(
        builder: (BuildContext context, int? muteSetStatus, Widget? child) {
          return CupertinoSwitch(
              activeColor: Flavors.colorInfo.mainColor,
              value: muteSetStatus == 0 ? true : false,
              onChanged: (bool value) {
                print("DEBUG=> CupertinoSwitch $value");
                manager.switchSet("mute", value);
              });
        },
        selector: (BuildContext context, SettingManager settingManager) {
          return settingManager.muteStatus ?? 0;
        },
        shouldRebuild: (pre, next) => (pre != next));
  }

  Widget _shockSet() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      color: Flavors.colorInfo.mainBackGroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text('震动'), _switchShockView()],
      ),
    );
  }

  Widget _switchShockView() {
    return Selector<SettingManager, int>(
        builder: (BuildContext context, int? shockSetStatus, Widget? child) {
          return CupertinoSwitch(
              activeColor: Flavors.colorInfo.mainColor,
              value: shockSetStatus == 0 ? true : false,
              onChanged: (bool value) {
                print("DEBUG=> CupertinoSwitch $value");
                manager.switchSet("shock", value);
              });
        },
        selector: (BuildContext context, SettingManager settingManager) {
          return settingManager.shockStatus ?? 0;
        },
        shouldRebuild: (pre, next) => (pre != next));
  }

  Widget _noticeSet() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      color: Flavors.colorInfo.mainBackGroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text('消息通知'), _switchNoticeView()],
      ),
    );
  }

  Widget _switchNoticeView() {
    return Selector<SettingManager, int>(
        builder: (BuildContext context, int? noticeSetStatus, Widget? child) {
          return CupertinoSwitch(
              activeColor: Flavors.colorInfo.mainColor,
              value: noticeSetStatus == 0 ? true : false,
              onChanged: (bool value) {
                print("DEBUG=> CupertinoSwitch $value");
                manager.switchSet("notice", value);
              });
        },
        selector: (BuildContext context, SettingManager settingManager) {
          return settingManager.noticeStatus ?? 0;
        },
        shouldRebuild: (pre, next) => (pre != next));
  }
}
