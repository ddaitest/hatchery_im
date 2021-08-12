import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:provider/provider.dart';
import 'package:hatchery_im/manager/contacts_manager/friendApplyManager.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';

class FriendApplyPage extends StatelessWidget {
  final String? usersID;
  FriendApplyPage({this.usersID});

  final manager = App.manager<FriendApplyManager>();

  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (context) => FriendApplyManager(),
        child: Scaffold(
            appBar: AppBarFactory.backButton('申请添加好友'),
            body: Container(
                padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.0.h),
                    Text(
                      '申请理由',
                      style: Flavors.textStyles.friendApplyTitleText,
                    ),
                    _applyTextView(),
                    Text(
                      '设置备注',
                      style: Flavors.textStyles.friendApplyTitleText,
                    ),
                    _remarkView(),
                    _submitBtn()
                  ],
                ))));
  }

  Widget _applyTextView() {
    return Container(
      padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
      height: 100.0.h,
      child: TextFormField(
        controller: manager.applyTextEditingController,
        cursorColor: Flavors.colorInfo.mainColor,
        keyboardType: TextInputType.text,
        maxLength: 50,
        minLines: 3,
        maxLines: 3,
        obscureText: false,
        autofocus: false,
        decoration: InputDecoration(
          counterText: "",
          contentPadding: EdgeInsets.all(15.0),
          enabledBorder: OutlineInputBorder(
            //未选中时候的颜色
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            //选中时外边框颜色
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: Flavors.colorInfo.mainColor,
            ),
          ),
        ),
        style: TextStyle(
          color: Flavors.colorInfo.diver,
        ),
      ),
    );
  }

  Widget _remarkView() {
    return Container(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: TextFormField(
        controller: manager.remarkEditingController,
        cursorColor: Flavors.colorInfo.mainColor,
        maxLength: 20,
        minLines: 1,
        maxLines: 1,
        obscureText: false,
        autofocus: false,
        decoration: InputDecoration(
          counterText: "",
          contentPadding: EdgeInsets.all(15.0),
          enabledBorder: OutlineInputBorder(
            //未选中时候的颜色
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            //选中时外边框颜色
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: Flavors.colorInfo.mainColor,
            ),
          ),
        ),
        style: TextStyle(
          color: Flavors.colorInfo.diver,
        ),
      ),
    );
  }

  Widget _submitBtn() {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(top: 50.0),
        width: Flavors.sizesInfo.screenWidth,
        child: TextButton(
          onPressed: () => _submit(),
          style: ElevatedButton.styleFrom(
            elevation: 0.0,
            primary: Flavors.colorInfo.mainColor,
            padding: EdgeInsets.only(top: 17.0, bottom: 17.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            '提交申请',
            textAlign: TextAlign.center,
            style: Flavors.textStyles.friendApplyBtnText,
          ),
        ),
      ),
    );
  }

  void _submit() {
    String desc = manager.applyTextEditingController.text;
    String remark = manager.remarkEditingController.text;
    print("DEBUG=> $desc $remark");
    manager.submitApply(usersID!, desc, remark);
  }
}
