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
import '../edit_profile/edit_detail.dart';

class FriendProfilePage extends StatefulWidget {
  final String? friendId;
  FriendProfilePage({this.friendId});
  @override
  _FriendProfilePageState createState() => _FriendProfilePageState();
}

class _FriendProfilePageState extends State<FriendProfilePage> {
  final manager = App.manager<FriendProfileManager>();
  @override
  void initState() {
    manager.init(widget.friendId!);
    super.initState();
  }

  @override
  void dispose() {
    manager.friendInfo = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarFactory.backButton(''), body: _mainContainer());
  }

  Widget _mainContainer() {
    return Selector<FriendProfileManager, Friends?>(
        builder: (BuildContext context, Friends? value, Widget? child) {
          return Container(
              padding: const EdgeInsets.only(left: 12, top: 12, right: 12),
              child: Column(
                children: [
                  _topViewForFriend(value),
                  _listInfoForFriend(value),
                  Container(height: 40.0),
                  _btnContainer(value),
                ],
              ));
        },
        selector:
            (BuildContext context, FriendProfileManager friendProfileManager) {
          return friendProfileManager.friendInfo ?? null;
        },
        shouldRebuild: (pre, next) => (pre != next));
  }

  Widget _topViewForFriend(friends) {
    return Container(
      padding: const EdgeInsets.only(left: 20, bottom: 40),
      child: Row(
        children: [
          friends != null
              ? netWorkAvatar(friends.icon, 40.0)
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
                friends != null
                    ? Text('昵称：${friends.nickName}',
                        style: Flavors.textStyles.friendProfileMainText)
                    : LoadingView(viewHeight: 20.0, viewWidth: 100.0.w),
                SizedBox(height: 10.0.h),
                friends != null
                    ? Text('备注：${friends.remarks ?? '无'}',
                        style: Flavors.textStyles.friendProfileSubtitleText)
                    : LoadingView(viewWidth: 70.0.w),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // todo
  // Widget _listContainer(friends) {
  //   if (friends != null) {}
  // }

  Widget _listInfoForFriend(friends) {
    return ListView(
      shrinkWrap: true,
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => FriendsProfileEditDetailPage(
                        widget.friendId!,
                        '设置备注',
                        friends!.remarks ?? '',
                      ))).then((value) =>
              value ?? false ? manager.refreshData(widget.friendId!) : null),
          child: _dataCellView("设置备注", ''),
        ),
        GestureDetector(
          onTap: () => Routers.navigateTo('/friend_info_more', arg: friends),
          child: _dataCellView(
            "更多信息",
            '',
          ),
        ),
        GestureDetector(
            onTap: () =>
                Routers.navigateTo('/friend_setting', arg: friends!.friendId),
            child: _dataCellView("其他设置", '', showDivider: false)),
      ],
    );
  }

  Widget _dataCellView(String title, String trailingText,
      {bool showDivider = true}) {
    return ProfileEditMenuItem(
      title,
      trailingText: trailingText,
      showForwardIcon: true,
      showDivider: showDivider,
    );
  }

  Widget _btnContainer(friends) {
    if (friends != null) {
      if (friends.status == 1) {
        return _sendBtnView(friends);
      } else {
        return _addFriendBtnView();
      }
    } else {
      return Container();
    }
  }

  Widget _sendBtnView(friends) {
    return Container(
      width: Flavors.sizesInfo.screenWidth,
      child: TextButton(
        onPressed: () => Routers.navigateReplace('/chat_detail', arg: friends),
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
        onPressed: () => null,
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
