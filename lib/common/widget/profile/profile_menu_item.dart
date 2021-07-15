import 'package:flutter/material.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/busniess/profile_page/edit_profile/edit_detail.dart';

class ProfileMenuItem extends StatelessWidget {
  final String leadingImagePath;
  final String menuText;
  final String trailingText;
  final GestureTapCallback? onTap;
  ProfileMenuItem(this.leadingImagePath, this.menuText,
      {this.trailingText = '', this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                menuText,
                style: Flavors.textStyles.meListTitleText,
              ),
              trailing: Container(
                padding: const EdgeInsets.only(right: 8.0, top: 4.0),
                width: 100.0.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      trailingText,
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
              onTap: onTap,
            ),
            dividerViewCommon(),
          ],
        ));
  }
}

class ProfileEditMenuItem extends StatelessWidget {
  final String menuText;
  final String trailingText;
  ProfileEditMenuItem(this.menuText, {this.trailingText = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            ListTile(
                dense: false,
                title: Text(
                  menuText,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: Flavors.textStyles.meListTitleText,
                ),
                trailing: Container(
                  padding: const EdgeInsets.only(top: 4.0),
                  width: 200.0.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        trailingText,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: Flavors.textStyles.loginSubTitleText,
                      ),
                      SizedBox(
                        width: 10.0.w,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey[400],
                        size: 15.0,
                      ),
                    ],
                  ),
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProfileEditDetailPage(
                              '$menuText',
                              trailingText,
                              '$menuText',
                              maxLength: menuText == '个人简介' || menuText == '地址'
                                  ? 60
                                  : 20,
                              maxLine: menuText == '个人简介' || menuText == '地址'
                                  ? 4
                                  : 2,
                              onlyNumber: menuText == '手机号' ? true : false,
                            )))),
            dividerViewCommon(),
          ],
        ));
  }
}
