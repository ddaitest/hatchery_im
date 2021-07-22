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

class FriendInfoMorePage extends StatelessWidget {
  final Friends friendInfo;
  FriendInfoMorePage(this.friendInfo);

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
      '手机号': friendInfo.phone ?? '无',
      '个性签名': friendInfo.notes ?? '无',
      '地址': friendInfo.address ?? '无',
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
