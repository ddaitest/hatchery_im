import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/common/widget/profile/profile_menu_item.dart';

class FriendInfoMorePage extends StatelessWidget {
  final UsersInfo usersInfo;
  FriendInfoMorePage(this.usersInfo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarFactory.backButton('更多信息'),
        body: Container(
          padding: const EdgeInsets.only(left: 12, top: 12, right: 12),
          child: _listInfo(),
        ));
  }

  Widget _listInfo() {
    return ListView(
      shrinkWrap: true,
      children: _checkMoreInfoMap(),
    );
  }

  List<Widget> _checkMoreInfoMap() {
    Map<String, String> infoMap = {
      '手机号': usersInfo.phone ?? '无',
      '个性签名': usersInfo.notes ?? '无',
      '地址': usersInfo.address ?? '无',
    };
    List<Widget> moreInfoList = [];
    infoMap.forEach((key, value) {
      moreInfoList.add(_dataCellView(key, value));
    });
    return moreInfoList;
  }

  Widget _dataCellView(String title, String trailingText,
      {bool showDivider = true}) {
    return ProfileEditMenuItem(
      title,
      trailingText: trailingText,
      showForwardIcon: false,
      showDivider: showDivider,
    );
  }
}
