import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/manager/friendProfileManager.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FriendSettingPage extends StatefulWidget {
  final String? friendId;
  FriendSettingPage({this.friendId});
  @override
  _FriendSettingPageState createState() => _FriendSettingPageState();
}

class _FriendSettingPageState extends State<FriendSettingPage> {
  final manager = App.manager<FriendProfileManager>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBarFactory.backButton(''),
            body: Container(
              padding: const EdgeInsets.only(left: 12, top: 12, right: 12),
              child: _listInfo(),
            )));
  }

  Future<bool> _onWillPop() async {
    Navigator.of(App.navState.currentContext!).pop(true);
    return true;
  }

  Widget _listInfo() {
    return ListView(
      shrinkWrap: true,
      children: [
        _blockView(),
        SizedBox(height: 40.0.h),
        _deleteBtnView(),
      ],
    );
  }

  Widget _blockView() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      color: Flavors.colorInfo.mainBackGroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text('加入黑名单'), _switchView()],
      ),
    );
  }

  Widget _switchView() {
    return Selector<FriendProfileManager, bool>(
        builder: (BuildContext context, bool isBlock, Widget? child) {
          return CupertinoSwitch(
              activeColor: Flavors.colorInfo.mainColor,
              value: isBlock,
              onChanged: (bool value) {
                print("DEBUG=> CupertinoSwitch $value");
                manager.setBlock(value, widget.friendId!);
              });
        },
        selector:
            (BuildContext context, FriendProfileManager friendProfileManager) {
          return friendProfileManager.isBlock;
        },
        shouldRebuild: (pre, next) => (pre != next));
  }

  Widget _deleteBtnView() {
    return TextButton(
      onPressed: () => _deleteConfirmDialog(widget.friendId!),
      style: ElevatedButton.styleFrom(
        elevation: 0.0,
        primary: Flavors.colorInfo.redColor,
        padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
      child: Text(
        '删除好友',
        textAlign: TextAlign.center,
        style: Flavors.textStyles.deleteFriendBtnText,
      ),
    );
  }

  _deleteConfirmDialog(String friendId) {
    return CoolAlert.show(
      context: App.navState.currentContext!,
      type: CoolAlertType.info,
      showCancelBtn: true,
      cancelBtnText: '取消',
      confirmBtnText: '确认',
      confirmBtnColor: Flavors.colorInfo.mainColor,
      onConfirmBtnTap: () {
        Navigator.of(App.navState.currentContext!).pop(true);
        manager.deleteFriend(friendId);
      },
      title: '确认删除好友?',
      text: "删除好友后将从联系人中移除",
    );
  }
}
