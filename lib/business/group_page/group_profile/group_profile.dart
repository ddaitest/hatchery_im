import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/manager/profile_manager/groupProfile_manager/groupProfileManager.dart';
import 'package:hatchery_im/common/widget/aboutAvatar.dart';
import 'package:hatchery_im/common/widget/profile/profile_menu_item.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/business/group_page/group_profile/groupMenuItem.dart';
import 'package:hatchery_im/common/widget/loading_view.dart';
import 'package:hatchery_im/business/profile_page/body.dart';
import 'package:hatchery_im/business/group_page/group_profile/groupProfileMembersModel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GroupProfilePage extends StatefulWidget {
  final String? groupID;
  GroupProfilePage({this.groupID});
  @override
  _GroupProfilePageState createState() => _GroupProfilePageState();
}

class _GroupProfilePageState extends State<GroupProfilePage> {
  final manager = App.manager<GroupProfileManager>();
  @override
  void initState() {
    manager.init(widget.groupID!);
    super.initState();
  }

  @override
  void dispose() {
    manager.isManager = false;
    manager.groupInfo = null;
    manager.groupMembersList?.clear();
    manager.nickNameForGroup = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(
              title: Selector<GroupProfileManager, List<GroupMembers>?>(
                  builder: (BuildContext context, List<GroupMembers>? value,
                      Widget? child) {
                    return Text(
                      value != null ? '群组信息(${value.length})' : '群组信息',
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    );
                  },
                  selector: (BuildContext context,
                      GroupProfileManager groupProfileManager) {
                    return groupProfileManager.groupMembersList ?? null;
                  },
                  shouldRebuild: (pre, next) => (pre != next)),
              centerTitle: true,
              backgroundColor: Flavors.colorInfo.mainBackGroundColor,
              brightness: Brightness.light,
              elevation: 0.0,
              leading: Container(
                padding: const EdgeInsets.all(6.0),
                child: IconButton(
                  icon:
                      Icon(Icons.chevron_left, size: 30.0, color: Colors.black),
                  onPressed: () =>
                      Navigator.of(App.navState.currentContext!).pop(true),
                ),
              ),
              automaticallyImplyLeading: false,
              actions: [
                TextButton(
                  onPressed: () => dialogModel(
                      titleText: '确认退出群组?',
                      confirmText: '退出群组后将无法撤回',
                      confirmBtnTap: () {
                        Navigator.of(App.navState.currentContext!).pop(false);
                        manager.quitGroupRes(widget.groupID!);
                      }),
                  child: Text(
                    "退群",
                    style: Flavors.textStyles.groupProfileQuitBtnText,
                  ),
                ),
              ],
            ),
            body: ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                _membersView(),
                SizedBox(height: 8.0.h),
                _groupInfoView(),
                SizedBox(height: 30.0.h),
                _joinGroupChatDetailBtn(),
              ],
            )));
  }

  Future<bool> _onWillPop() async {
    Navigator.of(App.navState.currentContext!).pop(true);
    return true;
  }

  Widget _groupInfoView() {
    print("DEBUG=> _groupInfoView");
    return Selector<GroupProfileManager, GroupInfo?>(
        builder: (BuildContext context, GroupInfo? value, Widget? child) {
          return Container(
            child: Column(
              children: [
                GroupProfileMenuItem(
                  titleText: '群组名称',
                  trailingText: '${value?.groupName ?? ''}',
                  showDivider: false,
                  trailingView: manager.isManager ? null : Container(),
                  onTap: () => manager.isManager
                      ? Routers.navigateTo('/group_profile_edit_detail', arg: {
                          'groupId': widget.groupID,
                          'appBarText': '群组名称',
                          'inputText': '${value!.groupName ?? ''}',
                          'hintText': '修改群组名称',
                          'maxLength': 20,
                          'maxLine': 1,
                          'onlyNumber': false,
                          'sendType': 1
                        }).then((value) =>
                          value ? manager.refreshData(widget.groupID!) : null)
                      : null,
                ),
                GroupProfileMenuItem(
                  titleText: '群简介',
                  trailingText: '${value?.groupDescription ?? '没有群简介'}',
                  showDivider: false,
                  trailingView: manager.isManager ? null : Container(),
                  onTap: () => manager.isManager
                      ? Routers.navigateTo('/group_profile_edit_detail', arg: {
                          'groupId': widget.groupID,
                          'appBarText': '群简介',
                          'inputText': '${value!.groupDescription ?? ''}',
                          'hintText': '修改群简介',
                          'maxLength': 40,
                          'maxLine': 4,
                          'onlyNumber': false,
                          'sendType': 2
                        }).then((value) =>
                          value ? manager.refreshData(widget.groupID!) : null)
                      : null,
                ),
                GroupProfileMenuItem(
                  titleText: '群公告',
                  trailingText: '${value?.notes ?? '未设置'}',
                  trailingTextMaxLine: 2,
                  showDivider: false,
                  trailingView: manager.isManager ? null : Container(),
                  onTap: () => manager.isManager
                      ? Routers.navigateTo('/group_profile_edit_detail', arg: {
                          'groupId': widget.groupID,
                          'appBarText': '群公告',
                          'inputText': '${value!.notes ?? ''}',
                          'hintText': '修改群公告',
                          'maxLength': 40,
                          'maxLine': 4,
                          'onlyNumber': false,
                          'sendType': 3
                        }).then((value) =>
                          value ? manager.refreshData(widget.groupID!) : null)
                      : null,
                ),
                _groupNickNameItem()
              ],
            ),
          );
        },
        selector:
            (BuildContext context, GroupProfileManager groupProfileManager) {
          return groupProfileManager.groupInfo ?? null;
        },
        shouldRebuild: (pre, next) => (pre != next));
  }

  Widget _groupNickNameItem() {
    print("DEBUG=> _groupNickNameItem");
    return Selector<GroupProfileManager, String?>(
        builder: (BuildContext context, String? value, Widget? child) {
          return GroupProfileMenuItem(
            titleText: '我在本群的昵称',
            trailingText: '${manager.nickNameForGroup ?? ''}',
            trailingTextMaxLine: 1,
            showDivider: false,
            onTap: () => Routers.navigateTo('/group_profile_edit_detail', arg: {
              'groupId': widget.groupID,
              'appBarText': '我在本群的昵称',
              'inputText': '${manager.nickNameForGroup ?? ''}',
              'hintText': '修改昵称',
              'maxLength': 20,
              'maxLine': 1,
              'onlyNumber': false,
              'sendType': 4
            }).then(
                (value) => value ? manager.refreshData(widget.groupID!) : null),
          );
        },
        selector:
            (BuildContext context, GroupProfileManager groupProfileManager) {
          return groupProfileManager.nickNameForGroup ?? '';
        },
        shouldRebuild: (pre, next) => (pre != next));
  }

  Widget _membersView() {
    return Selector<GroupProfileManager, List<GroupMembers>?>(
        builder:
            (BuildContext context, List<GroupMembers>? value, Widget? child) {
          return GroupMembersGrid(widget.groupID, value);
        },
        selector:
            (BuildContext context, GroupProfileManager groupProfileManager) {
          return groupProfileManager.groupMembersList ?? null;
        },
        shouldRebuild: (pre, next) => (pre != next));
  }

  Widget _joinGroupChatDetailBtn() {
    return Container(
      child: TextButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          elevation: 0.0,
          primary: Flavors.colorInfo.mainBackGroundColor,
          padding: const EdgeInsets.only(top: 18.0, bottom: 18.0),
        ),
        child: Text(
          '进入群聊',
          textAlign: TextAlign.center,
          style: Flavors.textStyles.friendProfileBtnText,
        ),
      ),
    );
  }
}
