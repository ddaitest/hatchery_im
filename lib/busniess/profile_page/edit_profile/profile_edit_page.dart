import 'package:flutter/material.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/manager/profileEditManager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/widget/aboutAvatar.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/common/widget/profile/profile_menu_item.dart';

class ProfileEditPage extends StatefulWidget {
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final manager = App.manager<ProfileEditManager>();
  @override
  void initState() {
    manager.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.backButton('编辑资料'),
      body: Container(
        padding: EdgeInsets.only(left: 12, top: 25, right: 12),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 4,
                          color: Theme.of(context).scaffoldBackgroundColor),
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0, 10))
                      ],
                      shape: BoxShape.circle,
                    ),
                    child: netWorkAvatar(manager.imageUrl!, 60.0),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40.0.h,
                        width: 40.0.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          color: Flavors.colorInfo.mainColor,
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(height: 65.0.h),
            ProfileEditMenuItem("昵称",
                trailingText: manager.myProfileData!.nickName),
            ProfileEditMenuItem("个人简介",
                trailingText: manager.myProfileData!.notes ?? '无'),
            ProfileEditMenuItem("手机号",
                trailingText: manager.myProfileData!.phone ?? '无'),
            ProfileEditMenuItem("电子邮箱",
                trailingText: manager.myProfileData!.email ?? '无'),
            ProfileEditMenuItem("地址",
                trailingText: manager.myProfileData!.address ?? '无'),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController textEditingController,
      String labelText, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 3),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
        ),
      ),
    );
  }

  void _submit(loginManager) {
    String phoneNum = loginManager.phoneNumController.text;
    String phoneNumberAreaCode = loginManager.phoneNumberAreaCode;
    String phoneCode = loginManager.phoneCodeController.text;
    print("DEBUG=> $phoneNum");
    if (phoneNum == '') {
      showToast('手机号不能为空');
    } else if (phoneCode == '') {
      showToast('验证码不能为空');
    } else {
      loginManager.phoneSubmit(phoneNum, phoneNumberAreaCode, phoneCode);
    }
  }
}
