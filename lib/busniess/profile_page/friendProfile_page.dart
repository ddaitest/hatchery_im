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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarFactory.backButton('', actions: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 9.0),
            child: Icon(Icons.more_vert, size: 30, color: Colors.black),
          )
        ]),
        body: Container(
            padding: const EdgeInsets.only(left: 12, top: 20, right: 12),
            child: Column(
              children: [
                _topView(),
                _listInfo(),
                Container(height: 40.0),
                _btnView(),
              ],
            )));
  }

  Widget _topView() {
    return Selector<FriendProfileManager, FriendProfile?>(
      builder: (BuildContext context, FriendProfile? value, Widget? child) {
        print("DEBUG=> _FriendsProfileTopView 重绘了。。。。。");
        return Container(
          padding: const EdgeInsets.only(left: 20, bottom: 40),
          child: Row(
            children: [
              netWorkAvatar(value?.icon, 40.0),
              Container(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    value != null
                        ? Text('昵称：${value.nickName ?? ''}',
                            style: Flavors.textStyles.friendProfileMainText)
                        : LoadingView(viewHeight: 20.0, viewWidth: 100.0.w),
                    SizedBox(height: 10.0.h),
                    value != null
                        ? Text('备注：${value.remarks ?? '无'}',
                            style: Flavors.textStyles.friendProfileSubtitleText)
                        : LoadingView(viewWidth: 70.0.w),
                  ],
                ),
              ),
            ],
          ),
        );
        // return ListTile(
        //   onTap: () => Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (_) => ImageDetailViewPage(
        //               image: CachedNetworkImageProvider(value!.icon!)))),
        //   leading: netWorkAvatar(value?.icon, 60.0),
        //   title: value != null
        //       ? Text('昵称：${value.nickName ?? ''}')
        //       : LoadingView(viewWidth: 100.0.w),
        //   subtitle: value != null
        //       ? Text('备注：${value.remarks ?? '无'}')
        //       : LoadingView(viewWidth: 50.0.w),
        // );
      },
      selector:
          (BuildContext context, FriendProfileManager friendProfileManager) {
        return friendProfileManager.friendProfileData ?? null;
      },
      shouldRebuild: (pre, next) => (pre != next),
    );
  }

  Widget _listInfo() {
    return ListView(
      shrinkWrap: true,
      children: [
        _dataCellView("设置备注", ''),
        _dataCellView("更多信息", '', showDivider: false),
      ],
    );
  }

  Widget _dataCellView(String title, String trailingText,
      {bool isTap = true, bool showDivider = true}) {
    return GestureDetector(
      // onTap: () => isTap
      //     ? Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (_) => ProfileEditDetailPage(
      //           '$title',
      //           trailingText,
      //           '$title',
      //           maxLength: title == '个人简介' || title == '地址' ? 60 : 20,
      //           maxLine: title == '个人简介' || title == '地址' ? 4 : 2,
      //           onlyNumber: title == '手机号' ? true : false,
      //         ))).then((value) => value ? manager.refreshData() : null)
      //     : null,
      child: ProfileEditMenuItem(
        title,
        trailingText: trailingText,
        showForwardIcon: isTap ? true : false,
        showDivider: showDivider,
      ),
    );
  }

  Widget _btnView() {
    return Container(
      height: 70.0,
      color: Colors.white,
      child: TextButton(
        onPressed: () => Routers.navigateReplace(
          '/chat_detail',
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.messenger_outline,
                size: 23.0, color: Flavors.colorInfo.mainColor),
            SizedBox(width: 8.0.w),
            Text(
              '发消息',
              textAlign: TextAlign.center,
              style: Flavors.textStyles.friendProfileBtnText,
            )
          ],
        ),
      ),
    );
  }
}
