import 'package:flutter/material.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'info.dart';
import 'package:hatchery_im/routers.dart';
import '../../common/widget/profile/profile_menu_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileBody extends StatelessWidget {
  final myProfileManager;
  ProfileBody(this.myProfileManager);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Info(
          imageUrl: "${myProfileManager.myProfileData.icon}",
          name: "${myProfileManager.myProfileData.nickName ?? ''}",
          account: "${myProfileManager.myProfileData.loginName ?? ''}",
          userID: "${myProfileManager.myProfileData.userID ?? null}",
        ),
        SizedBox(height: 20.0.h),
        ProfileMenuItem('images/notice.png', "消息通知"),
        ProfileMenuItem('images/language.png', "语言", trailingText: '中文'),
        ProfileMenuItem('images/support.png', "清理缓存",
            trailingText: '${myProfileManager.cacheSize}', onTap: () {
          if (myProfileManager.cacheSize != "0.00B" &&
              myProfileManager.cacheSize != "")
            myProfileManager.deleteCacheData();
        }),
        ProfileMenuItem(
          'images/block.png',
          "黑名单列表",
          onTap: () => Routers.navigateTo('/block_list'),
        ),
        ProfileMenuItem(
          'images/setting.png',
          "关于",
          showDivider: false,
          onTap: () => Routers.navigateTo('/about'),
        ),
        SizedBox(height: 20.0.h),
        _logOutBtnView(),
      ],
    );
  }

  Widget _logOutBtnView() {
    return GestureDetector(
      onTap: () => myProfileManager.logOutMethod(),
      child: Container(
        height: 50.0.h,
        width: Flavors.sizesInfo.screenWidth,
        color: Colors.white,
        child: Center(
            child: Text('退出登录', style: Flavors.textStyles.meListTitleText)),
      ),
    );
  }
}
