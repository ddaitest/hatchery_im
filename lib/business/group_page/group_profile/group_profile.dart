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
                  icon: Icon(Icons.arrow_back, size: 30.0, color: Colors.black),
                  onPressed: () =>
                      Navigator.of(App.navState.currentContext!).pop(true),
                ),
              ),
              automaticallyImplyLeading: false,
            ),
            body: ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                _membersView(),
                SizedBox(height: 8.0.h),
                _groupInfoView()
              ],
            )));
  }

  Future<bool> _onWillPop() async {
    Navigator.of(App.navState.currentContext!).pop(true);
    return true;
  }

  Widget _groupInfoView() {
    return Selector<GroupProfileManager, GroupInfo?>(
        builder: (BuildContext context, GroupInfo? value, Widget? child) {
          return Container(
            child: Column(
              children: [
                GroupProfileMenuItem(
                  titleText: '群组名称',
                  trailingText: '${value?.groupName ?? ''}',
                  showDivider: false,
                ),
                GroupProfileMenuItem(
                  titleText: '群简介',
                  trailingText: '${value?.groupDescription ?? '没有群简介'}',
                  showDivider: false,
                ),
                GroupProfileMenuItem(
                  titleText: '群公告',
                  trailingText: '${value?.notes ?? '未设置'}',
                  trailingTextMaxLine: 2,
                  showDivider: false,
                ),
                GroupProfileMenuItem(
                  titleText: '我在本群的昵称',
                  trailingText: '${manager.nickNameForGroup ?? ''}',
                  trailingTextMaxLine: 1,
                  showDivider: false,
                  onTap: () => Routers.navigateTo('/profile_edit_detail', arg: {
                    'appBarText': '我在本群的昵称',
                    'inputText': '${manager.nickNameForGroup ?? ''}',
                    'hintText': '修改昵称',
                    'maxLength': 20,
                    'maxLine': 1,
                    'onlyNumber': false
                  }).then((value) =>
                      value ? manager.refreshData(widget.groupID!) : null),
                ),
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

  Widget _membersView() {
    return Selector<GroupProfileManager, List<GroupMembers>?>(
        builder:
            (BuildContext context, List<GroupMembers>? value, Widget? child) {
          return GroupMembersGrid(value);
        },
        selector:
            (BuildContext context, GroupProfileManager groupProfileManager) {
          return groupProfileManager.groupMembersList ?? null;
        },
        shouldRebuild: (pre, next) => (pre != next));
  }

  Widget _topViewForFriend(usersInfo) {
    return Container(
      padding: const EdgeInsets.only(left: 20, bottom: 40),
      child: Row(
        children: [
          usersInfo != null
              ? netWorkAvatar(usersInfo.icon, 40.0)
              : CircleAvatar(
                  backgroundImage: AssetImage('images/default_avatar.png'),
                  maxRadius: 40.0,
                ),
          Container(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                usersInfo != null
                    ? Text('昵称：${usersInfo.nickName}',
                        style: Flavors.textStyles.friendProfileMainText)
                    : LoadingView(viewHeight: 20.0, viewWidth: 100.0.w),
                SizedBox(height: 10.0.h),
                usersInfo != null
                    ? usersInfo.status == 1
                        ? Text('备注：${usersInfo.remarks ?? '无'}',
                            style: Flavors.textStyles.friendProfileSubtitleText)
                        : Container()
                    : LoadingView(viewWidth: 70.0.w),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _listContainer(UsersInfo? usersInfo) {
  //   if (usersInfo != null) {
  //     if (usersInfo.isFriends) {
  //       return _listInfoForFriend(usersInfo);
  //     } else {
  //       return _listInfoForStranger();
  //     }
  //   } else {
  //     return Container();
  //   }
  // }

  // Widget _listInfoForFriend(usersInfo) {
  //   return ListView(
  //     shrinkWrap: true,
  //     children: [
  //       GestureDetector(
  //         onTap: () => Navigator.push(
  //             App.navState.currentContext!,
  //             MaterialPageRoute(
  //                 builder: (_) => FriendsProfileEditDetailPage(
  //                       widget.userID!,
  //                       '设置备注',
  //                       usersInfo!.remarks ?? '',
  //                     ))).then((value) =>
  //             value ?? false ? manager.refreshData(widget.userID!) : null),
  //         child: _dataCellView("设置备注", ''),
  //       ),
  //       GestureDetector(
  //         onTap: () => Routers.navigateTo('/friend_info_more', arg: usersInfo),
  //         child: _dataCellView(
  //           "更多信息",
  //           '',
  //         ),
  //       ),
  //       GestureDetector(
  //           onTap: () =>
  //               Routers.navigateTo('/friend_setting', arg: usersInfo!.userID)
  //                   .then((value) => value ?? false
  //                       ? manager.refreshData(widget.userID!)
  //                       : null),
  //           child: _dataCellView("其他设置", '', showDivider: false)),
  //     ],
  //   );
  // }
  //
  // Widget _listInfoForStranger() {
  //   Map<String, dynamic> userMap = manager.usersInfoMap!;
  //   userMap.removeWhere((key, value) => (value == null ||
  //       key == 'userID' ||
  //       key == 'icon' ||
  //       key == 'status' ||
  //       key == 'updateTime' ||
  //       key == 'createTime' ||
  //       key == 'isFriends' ||
  //       key == 'nickName'));
  //   print("DEBUG=> usersInfoMap2 $userMap");
  //   return ListView.builder(
  //       itemCount: userMap.length,
  //       shrinkWrap: true,
  //       physics: const BouncingScrollPhysics(),
  //       itemBuilder: (context, index) {
  //         return _dataCellView("${profileTitle(userMap.keys.toList()[index])}",
  //             "${userMap.values.toList()[index]}",
  //             showForwardIcon: false);
  //       });
  // }
  //
  // Widget _dataCellView(String title, String trailingText,
  //     {bool showForwardIcon = true, bool showDivider = true}) {
  //   return ProfileEditMenuItem(
  //     title,
  //     trailingText: trailingText,
  //     showForwardIcon: showForwardIcon,
  //     showDivider: showDivider,
  //   );
  // }
  //
  // Widget _btnContainer(usersInfo) {
  //   if (usersInfo != null) {
  //     if (usersInfo.status == 1) {
  //       return _sendBtnView(usersInfo);
  //     } else {
  //       return _addFriendBtnView();
  //     }
  //   } else {
  //     return Container();
  //   }
  // }
  //
  // Widget _sendBtnView(usersInfo) {
  //   return Container(
  //     width: Flavors.sizesInfo.screenWidth,
  //     child: TextButton(
  //       onPressed: () =>
  //           Routers.navigateReplace('/chat_detail', arg: usersInfo),
  //       style: ElevatedButton.styleFrom(
  //         elevation: 0.0,
  //         primary: Flavors.colorInfo.mainBackGroundColor,
  //         padding: EdgeInsets.only(top: 18.0, bottom: 18.0),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(4.0),
  //         ),
  //       ),
  //       child: Text(
  //         '发消息',
  //         textAlign: TextAlign.center,
  //         style: Flavors.textStyles.friendProfileBtnText,
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _addFriendBtnView() {
  //   return Container(
  //     width: Flavors.sizesInfo.screenWidth,
  //     child: TextButton(
  //       onPressed: () =>
  //           Routers.navigateTo('/friend_apply', arg: widget.userID!),
  //       style: ElevatedButton.styleFrom(
  //         elevation: 0.0,
  //         primary: Flavors.colorInfo.mainBackGroundColor,
  //         padding: EdgeInsets.only(top: 18.0, bottom: 18.0),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(4.0),
  //         ),
  //       ),
  //       child: Text(
  //         '添加好友',
  //         textAlign: TextAlign.center,
  //         style: Flavors.textStyles.friendProfileBtnText,
  //       ),
  //     ),
  //   );
  // }
}
