import 'package:flutter/material.dart';
import 'package:hatchery_im/manager/chat_manager/chatSettingManager.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/manager/profile_manager/friendsProfile_manager/friendProfileManager.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../routers.dart';

class ChatSettingPage extends StatefulWidget {
  final String? otherId;
  final String? chatType;
  ChatSettingPage({this.otherId, this.chatType});
  @override
  _ChatSettingPageState createState() => _ChatSettingPageState();
}

class _ChatSettingPageState extends State<ChatSettingPage> {
  final manager = App.manager<ChatSettingManager>();
  @override
  void initState() {
    manager.init(widget.otherId, widget.chatType);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarFactory.backButton(''),
        body: Container(
          padding: const EdgeInsets.only(left: 12.0, top: 12.0, right: 12.0),
          child: _listInfo(),
        ));
  }

  Future<bool> _onWillPop() async {
    Navigator.of(App.navState.currentContext!).pop(true);
    return true;
  }

  Widget _listInfo() {
    return ListView(
      shrinkWrap: true,
      children: [
        _messageTopSet(),
        _messageMuteSet(),
        // SizedBox(height: 40.0.h),
        // _deleteHistoryMessageBtnView()
      ],
    );
  }

  Widget _messageTopSet() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      color: Flavors.colorInfo.mainBackGroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text('置顶消息'), _switchTopView()],
      ),
    );
  }

  Widget _switchTopView() {
    return Selector<ChatSettingManager, bool>(
        builder: (BuildContext context, bool isTop, Widget? child) {
          return CupertinoSwitch(
              activeColor: Flavors.colorInfo.mainColor,
              value: isTop,
              onChanged: (bool value) {
                print("DEBUG=> CupertinoSwitch $value");
                manager.setTopMsgSwitch(widget.otherId ?? "", !isTop);
              });
        },
        selector:
            (BuildContext context, ChatSettingManager chatSettingManager) {
          return chatSettingManager.isTop;
        },
        shouldRebuild: (pre, next) => (pre != next));
  }

  Widget _messageMuteSet() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      color: Flavors.colorInfo.mainBackGroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text('消息静音'), _switchMuteView()],
      ),
    );
  }

  Widget _switchMuteView() {
    return Selector<ChatSettingManager, bool>(
        builder: (BuildContext context, bool isMute, Widget? child) {
          return CupertinoSwitch(
              activeColor: Flavors.colorInfo.mainColor,
              value: isMute,
              onChanged: (bool value) {
                print("DEBUG=> CupertinoSwitch $value");
                manager.setMuteMsgSwitch(widget.otherId ?? "", !isMute);
              });
        },
        selector:
            (BuildContext context, ChatSettingManager chatSettingManager) {
          return chatSettingManager.isMute;
        },
        shouldRebuild: (pre, next) => (pre != next));
  }

  // Widget _deleteHistoryMessageBtnView() {
  //   return TextButton(
  //     onPressed: () => _deleteConfirmDialog(widget.otherId!),
  //     style: ElevatedButton.styleFrom(
  //       elevation: 0.0,
  //       primary: Flavors.colorInfo.redColor,
  //       padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(4.0),
  //       ),
  //     ),
  //     child: Text(
  //       '删除本地消息记录',
  //       textAlign: TextAlign.center,
  //       style: Flavors.textStyles.deleteFriendBtnText,
  //     ),
  //   );
  // }
  //
  // _deleteConfirmDialog(String friendId) {
  //   return CoolAlert.show(
  //     context: App.navState.currentContext!,
  //     type: CoolAlertType.warning,
  //     showCancelBtn: true,
  //     cancelBtnText: '取消',
  //     confirmBtnText: '删除',
  //     confirmBtnColor: Flavors.colorInfo.mainColor,
  //     onConfirmBtnTap: () {
  //       Navigator.of(App.navState.currentContext!).pop(true);
  //       manager.deleteMsgHistory(widget.otherId);
  //     },
  //     title: '确认清空聊天记录?',
  //     text: "删除后此好友/群组的本地聊天记录将被移除",
  //   );
  // }
}
