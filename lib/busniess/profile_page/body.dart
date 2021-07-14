import 'package:flutter/material.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'info.dart';
import '../../common/widget/profile/profile_menu_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileBody extends StatelessWidget {
  final myProfileManager;
  ProfileBody(this.myProfileManager);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Info(
            imageUrl: "${myProfileManager.myProfileData.icon}",
            name: "${myProfileManager.myProfileData.nickName}",
            account: "${myProfileManager.myProfileData.loginName}",
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
          ProfileMenuItem('images/setting.png', "关于"),
          SizedBox(height: 20.0.h),
          _logOutBtnView(),
        ],
      ),
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
