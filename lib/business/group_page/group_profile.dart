import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/manager/friendProfileManager.dart';
import 'package:hatchery_im/common/widget/aboutAvatar.dart';
import 'package:hatchery_im/common/widget/profile/profile_menu_item.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/common/widget/imageDetail.dart';
import 'package:hatchery_im/common/widget/loading_view.dart';
import 'package:hatchery_im/common/widget/loading_Indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GroupProfilePage extends StatefulWidget {
  final String? groupID;
  GroupProfilePage({this.groupID});
  @override
  _GroupProfilePageState createState() => _GroupProfilePageState();
}

class _GroupProfilePageState extends State<GroupProfilePage> {
  final manager = App.manager<FriendProfileManager>();
  @override
  void initState() {
    manager.init(widget.groupID!);
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
            appBar: AppBarFactory.backButton(''), body: _mainContainer()));
  }

  Future<bool> _onWillPop() async {
    Navigator.of(App.navState.currentContext!).pop(true);
    return true;
  }

  Widget _mainContainer() {
    return Selector<FriendProfileManager, UsersInfo?>(
        builder: (BuildContext context, UsersInfo? value, Widget? child) {
          return Container(
              padding: const EdgeInsets.only(left: 12, top: 12, right: 12),
              child: Column(
                children: [
                  _topViewForFriend(value),
                  _listContainer(value),
                  Container(height: 40.0.h),
                  _btnContainer(value),
                  manager.isBlock ? _blockWarnTextContainer() : Container()
                ],
              ));
        },
        selector:
            (BuildContext context, FriendProfileManager friendProfileManager) {
          return friendProfileManager.usersInfo ?? null;
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

  Widget _listContainer(UsersInfo? usersInfo) {
    if (usersInfo != null) {
      if (usersInfo.isFriends) {
        return _listInfoForFriend(usersInfo);
      } else {
        return _listInfoForStranger();
      }
    } else {
      return Container();
    }
  }

  Widget _listInfoForFriend(usersInfo) {
    return ListView(
      shrinkWrap: true,
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
              App.navState.currentContext!,
              MaterialPageRoute(
                  builder: (_) => FriendsProfileEditDetailPage(
                        widget.userID!,
                        '设置备注',
                        usersInfo!.remarks ?? '',
                      ))).then((value) =>
              value ?? false ? manager.refreshData(widget.userID!) : null),
          child: _dataCellView("设置备注", ''),
        ),
        GestureDetector(
          onTap: () => Routers.navigateTo('/friend_info_more', arg: usersInfo),
          child: _dataCellView(
            "更多信息",
            '',
          ),
        ),
        GestureDetector(
            onTap: () =>
                Routers.navigateTo('/friend_setting', arg: usersInfo!.userID)
                    .then((value) => value ?? false
                        ? manager.refreshData(widget.userID!)
                        : null),
            child: _dataCellView("其他设置", '', showDivider: false)),
      ],
    );
  }

  Widget _listInfoForStranger() {
    Map<String, dynamic> userMap = manager.usersInfoMap!;
    userMap.removeWhere((key, value) => (value == null ||
        key == 'userID' ||
        key == 'icon' ||
        key == 'status' ||
        key == 'updateTime' ||
        key == 'createTime' ||
        key == 'isFriends' ||
        key == 'nickName'));
    print("DEBUG=> usersInfoMap2 $userMap");
    return ListView.builder(
        itemCount: userMap.length,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return _dataCellView("${profileTitle(userMap.keys.toList()[index])}",
              "${userMap.values.toList()[index]}",
              showForwardIcon: false);
        });
  }

  Widget _dataCellView(String title, String trailingText,
      {bool showForwardIcon = true, bool showDivider = true}) {
    return ProfileEditMenuItem(
      title,
      trailingText: trailingText,
      showForwardIcon: showForwardIcon,
      showDivider: showDivider,
    );
  }

  Widget _btnContainer(usersInfo) {
    if (usersInfo != null) {
      if (usersInfo.status == 1) {
        return _sendBtnView(usersInfo);
      } else {
        return _addFriendBtnView();
      }
    } else {
      return Container();
    }
  }

  Widget _blockWarnTextContainer() {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(top: 30.0),
        child: Text('已添加到黑名单，你将不再收到对方的消息',
            style: Flavors.textStyles.friendProfileBlockWarnText),
      ),
    );
  }

  Widget _sendBtnView(usersInfo) {
    return Container(
      width: Flavors.sizesInfo.screenWidth,
      child: TextButton(
        onPressed: () =>
            Routers.navigateReplace('/chat_detail', arg: usersInfo),
        style: ElevatedButton.styleFrom(
          elevation: 0.0,
          primary: Flavors.colorInfo.mainBackGroundColor,
          padding: EdgeInsets.only(top: 18.0, bottom: 18.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        child: Text(
          '发消息',
          textAlign: TextAlign.center,
          style: Flavors.textStyles.friendProfileBtnText,
        ),
      ),
    );
  }

  Widget _addFriendBtnView() {
    return Container(
      width: Flavors.sizesInfo.screenWidth,
      child: TextButton(
        onPressed: () =>
            Routers.navigateTo('/friend_apply', arg: widget.userID!),
        style: ElevatedButton.styleFrom(
          elevation: 0.0,
          primary: Flavors.colorInfo.mainBackGroundColor,
          padding: EdgeInsets.only(top: 18.0, bottom: 18.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        child: Text(
          '添加好友',
          textAlign: TextAlign.center,
          style: Flavors.textStyles.friendProfileBtnText,
        ),
      ),
    );
  }
}
