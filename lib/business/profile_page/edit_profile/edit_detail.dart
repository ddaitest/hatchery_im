import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/manager/profile_manager/myProfile_manager/profileEditDetailManager.dart';
import 'package:hatchery_im/manager/profile_manager/friendsProfile_manager/friendProfileManager.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';

class ProfileEditDetailPage extends StatelessWidget {
  final String appBarText;
  final String inputText;
  final bool hideText;
  final String hintText;
  final int? maxLength;
  final int? maxLine;
  final bool onlyNumber;
  final TextEditingController textEditingController = TextEditingController();
  ProfileEditDetailPage(this.appBarText, this.inputText, this.hintText,
      {this.hideText = false,
      this.maxLength,
      this.maxLine = 1,
      this.onlyNumber = false});

  final manager = App.manager<ProfileEditDetailManager>();

  @override
  Widget build(BuildContext context) {
    textEditingController.text = inputText != '无' ? inputText : '';
    manager.setKeyName(appBarText);
    return Scaffold(
        appBar: AppBarFactory.backButton('编辑$appBarText', actions: [
          Container(
              padding: const EdgeInsets.all(6.0),
              child: TextButton(
                onPressed: () =>
                    manager.updateProfileData(textEditingController.text),
                child: Text(
                  '保存',
                  style: Flavors.textStyles.newGroupNextBtnText,
                ),
              )),
        ]),
        body: Container(
          padding: const EdgeInsets.only(right: 16.0, left: 16.0),
          child: TextFormField(
            controller: textEditingController,
            cursorColor: Flavors.colorInfo.subtitleColor,
            maxLength: maxLength,
            minLines: 1,
            maxLines: maxLine,
            obscureText: hideText,
            autofocus: true,
            style: TextStyle(
              color: Colors.black,
            ),
            inputFormatters: <TextInputFormatter>[
              if (onlyNumber) FilteringTextInputFormatter.digitsOnly, //只输入数字
            ],
          ),
        ));
  }
}

class FriendsProfileEditDetailPage extends StatelessWidget {
  final String friendId;
  final String appBarText;
  final String inputText;
  final bool hideText;
  final TextEditingController textEditingController = TextEditingController();
  FriendsProfileEditDetailPage(this.friendId, this.appBarText, this.inputText,
      {this.hideText = false});

  final manager = App.manager<FriendProfileManager>();

  @override
  Widget build(BuildContext context) {
    textEditingController.text = inputText;
    return Scaffold(
        appBar: AppBarFactory.backButton('$appBarText', actions: [
          Container(
              padding: const EdgeInsets.all(6.0),
              child: TextButton(
                onPressed: () => manager.setFriendRemark(
                    friendId, textEditingController.text),
                child: Text(
                  '提交',
                  style: Flavors.textStyles.newGroupNextBtnText,
                ),
              )),
        ]),
        body: Container(
          padding: const EdgeInsets.only(right: 16.0, left: 16.0),
          child: TextFormField(
            controller: textEditingController,
            cursorColor: Flavors.colorInfo.subtitleColor,
            maxLength: 10,
            minLines: 1,
            maxLines: 1,
            obscureText: false,
            autofocus: true,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ));
  }
}
