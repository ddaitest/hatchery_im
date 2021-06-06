import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hatchery_im/manager/myProfileManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/routers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyProfileManager(),
      child: _bodyContainer(),
    );
  }

  _bodyContainer() {
    return Consumer(builder: (BuildContext context,
        MyProfileManager myProfileManager, Widget? child) {
      return Scaffold(
          body: Container(
        width: Flavors.sizesInfo.screenWidth,
        child: Column(
          children: <Widget>[
            _topView(myProfileManager),
            Container(
              height: 20.0.h,
            ),
            _middleView()
          ],
        ),
      ));
    });
  }

  Widget _topView(myProfileManager) {
    return GestureDetector(
      onTap: () => Routers.navigateTo('/profile_edit'),
      child: Container(
        alignment: Alignment.center,
        height: 100.0.h,
        color: Colors.white,
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              // height: 50.0.h,
              // padding: const EdgeInsets.only(top: 20.0, left: 6.0, right: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  myProfileManager.myProfileData != ''
                      ? CachedNetworkImage(
                          imageUrl: myProfileManager.myProfileData.icon,
                          placeholder: (context, url) => CircleAvatar(
                                backgroundImage:
                                    AssetImage('images/default_avatar.png'),
                                maxRadius: 30,
                              ),
                          errorWidget: (context, url, error) => CircleAvatar(
                                backgroundImage:
                                    AssetImage('images/default_avatar.png'),
                                maxRadius: 30,
                              ),
                          imageBuilder: (context, imageProvider) {
                            return CircleAvatar(
                              backgroundImage: imageProvider,
                              maxRadius: 30,
                            );
                          })
                      : CircleAvatar(
                          backgroundImage:
                              AssetImage('images/default_avatar.png'),
                          maxRadius: 30,
                        ),
                  Container(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(myProfileManager.myProfileData.nickName ?? '',
                            style: Flavors.textStyles.meNickNameText),
                        SizedBox(height: 6.0),
                        Text(
                          '个性签名：${myProfileManager.myProfileData.notes ?? '无'}',
                          style: Flavors.textStyles.meNotesText,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Icon(
                    Icons.qr_code,
                    color: Colors.grey,
                    size: 25.0,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey[400],
                    size: 15.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _middleView() {
    return Column(
      children: <Widget>[
        _settingModelView('images/fav.png', "收藏"),
        _settingModelView('images/notice.png', "消息通知"),
        _settingModelView('images/language.png', "语言", settingText: '中文'),
        _settingModelView('images/support.png', "技术支持"),
        _settingModelView('images/setting.png', "关于"),
      ],
    );
  }

  Widget _settingModelView(String leadingImagePath, String text,
      {String settingText = ''}) {
    return Container(
        height: 50.0.h,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            ListTile(
              dense: false,
              leading: Container(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
                child: Image.asset(
                  leadingImagePath,
                ),
              ),
              title: Text(
                text,
                style: Flavors.textStyles.meListTitleText,
              ),
              trailing: Container(
                padding: const EdgeInsets.only(right: 8.0, top: 4.0),
                width: 80.0.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      settingText,
                      style: Flavors.textStyles.loginSubTitleText,
                    ),
                    SizedBox(
                      width: 8.0.w,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey[400],
                      size: 15.0,
                    ),
                  ],
                ),
              ),
              onTap: () {},
            ),
            Divider(
              height: 0.5,
              thickness: 0.5,
              color: Flavors.colorInfo.dividerColor,
              indent: 30,
              endIndent: 30,
            ),
          ],
        ));
  }
}
