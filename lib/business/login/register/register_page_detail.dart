import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/manager/register_manager/registerManager.dart';
import 'package:hatchery_im/common/widget/login_page/textForm_model.dart';

class RegisterPageDetail extends StatefulWidget {
  final String account;
  final String nickName;
  final String password;
  final String imageUrl;
  RegisterPageDetail(this.account, this.nickName, this.password, this.imageUrl);
  @override
  RegisterPageDetailState createState() => RegisterPageDetailState();
}

class RegisterPageDetailState extends State<RegisterPageDetail> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegisterManager(),
      child: _bodyContainer(),
    );
  }

  _bodyContainer() {
    return Consumer(builder:
        (BuildContext context, RegisterManager registerManager, Widget? child) {
      return Scaffold(
        appBar: AppBarFactory.backButton('',
            backGroundColor: Flavors.colorInfo.mainColor,
            backBtnColor: Flavors.colorInfo.mainBackGroundColor),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: <Widget>[
                mainBackGroundWidget(),
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 20.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '补充资料',
                          style: Flavors.textStyles.loginMainTitleText,
                        ),
                        SizedBox(height: 20.0.h),
                        _buildPhoneTF(registerManager),
                        SizedBox(height: 10.0.h),
                        _buildEmailTF(registerManager),
                        SizedBox(height: 10.0.h),
                        _buildNotesTF(registerManager),
                        SizedBox(height: 10.0.h),
                        _buildAddressTF(registerManager),
                        _buildFinishBtn(registerManager),
                        _skipAndFinishBtn(registerManager),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildPhoneTF(registerManager) {
    return TextFormModel(
      '手机号（用于短信验证码登录）',
      registerManager.phoneController,
      TextInputType.number,
      Icons.phone_android,
      '请输入手机号',
    );
  }

  Widget _buildEmailTF(registerManager) {
    return TextFormModel(
      '电子邮箱',
      registerManager.emailController,
      TextInputType.emailAddress,
      Icons.mail,
      '请输入电子邮箱地址',
    );
  }

  Widget _buildNotesTF(registerManager) {
    return TextFormModel(
      '个性签名',
      registerManager.notesController,
      TextInputType.text,
      Icons.article,
      '请输入个性签名',
      maxLine: 2,
      maxLength: 20,
    );
  }

  Widget _buildAddressTF(registerManager) {
    return TextFormModel(
      '地址',
      registerManager.addressController,
      TextInputType.text,
      Icons.location_on,
      '请输入地址',
      maxLine: 2,
      maxLength: 30,
    );
  }

  Widget _buildFinishBtn(registerManager) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: TextButton(
        style: ElevatedButton.styleFrom(
          primary: Flavors.colorInfo.mainBackGroundColor,
          textStyle: Flavors.textStyles.loginInButtonText,
          elevation: 5.0,
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: () => _submit(registerManager),
        child: Text(
          '完成注册',
          style: Flavors.textStyles.loginInButtonText,
        ),
      ),
    );
  }

  Widget _skipAndFinishBtn(registerManager) {
    return GestureDetector(
      onTap: () => _submit(registerManager),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Text(
          '跳过并完成注册',
          style: Flavors.textStyles.loginLinkText,
        ),
      ),
    );
  }

  ///提交
  _submit(registerManager) {
    String loginName = widget.account;
    String nickName = widget.nickName;
    String avatarUrl = widget.imageUrl;
    String password = widget.password;
    String notes = registerManager.notesController.text ?? '';
    String phone = registerManager.phoneController.text ?? '';
    String email = registerManager.emailController.text ?? '';
    String address = registerManager.addressController.text ?? '';
    if (loginName != '' &&
        nickName != '' &&
        avatarUrl != '' &&
        password != '') {
      print("test ${widget.account}");
      App.manager<RegisterManager>().submit(loginName, nickName, avatarUrl,
          password, notes, phone, email, address);
    }
  }
}
