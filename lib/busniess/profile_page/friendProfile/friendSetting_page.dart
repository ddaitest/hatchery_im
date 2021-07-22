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
import '../edit_profile/edit_detail.dart';

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
    return Scaffold(
        appBar: AppBarFactory.backButton(''),
        body: Container(
          padding: const EdgeInsets.only(left: 12, top: 12, right: 12),
          child: _listInfo(),
        ));
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
                manager.setBlock(value);
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
      onPressed: () {},
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
}
