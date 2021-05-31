import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/manager/registerManager.dart';
import 'package:hatchery_im/common/widget/login_page/textForm_model.dart';

class RegisterPageDetail extends StatefulWidget {
  @override
  RegisterPageDetailState createState() => RegisterPageDetailState();
}

class RegisterPageDetailState extends State<RegisterPageDetail> {
  RegisterManager _registerManager = RegisterManager();
  File _imageFile = File('');

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _registerManager,
      child: _bodyContainer(),
    );
  }

  _bodyContainer() {
    return Consumer(builder:
        (BuildContext context, RegisterManager registerManager, Widget? child) {
      return Scaffold(
        appBar: AppBarFactory.backButton('', actions: [
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                '跳过',
                style: Flavors.textStyles.loginLinkText,
              ),
            ),
          )
        ]),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF73AEF5),
                        Color(0xFF61A4F1),
                        Color(0xFF478DE0),
                        Color(0xFF398AE5),
                      ],
                      stops: [0.1, 0.4, 0.7, 0.9],
                    ),
                  ),
                ),
                Container(
                    height: double.infinity,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 20.0,
                      ),
                      child: Form(
                        key: registerManager.registerInputKey,
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
                            _buildNextBtn(registerManager),
                          ],
                        ),
                      ),
                    ))
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
      registerManager.accountController,
      TextInputType.number,
      Icons.phone_android,
      '请输入手机号',
    );
  }

  Widget _buildEmailTF(registerManager) {
    return TextFormModel(
      '电子邮箱',
      registerManager.nickNameController,
      TextInputType.emailAddress,
      Icons.mail,
      '请输入电子邮箱地址',
    );
  }

  Widget _buildNotesTF(registerManager) {
    return TextFormModel(
      '个性签名',
      registerManager.codeController,
      TextInputType.text,
      Icons.article,
      '请输入个性签名',
    );
  }

  Widget _buildAddressTF(registerManager) {
    return TextFormModel(
      '地址',
      registerManager.codeController,
      TextInputType.text,
      Icons.location_on,
      '请输入地址',
    );
  }

  Widget _buildNextBtn(registerManager) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 35.0),
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

  ///提交
  _submit(registerManager) {
    if (registerManager.registerInputKey.currentState!.validate()) {
      String account = registerManager.accountController.text;
      String password = registerManager.codeController.text;
      String nickName = registerManager.nickNameController.text;
      String avatarUrl = registerManager.uploadUrl;
      String notes = registerManager.notesController.text;
      String phone = registerManager.phoneController.text;
      String email = registerManager.emailController.text;
      String address = registerManager.addressController.text;
      print("test ${registerManager.aaa}");
      // App.manager<RegisterManager>().submit(account, password);
    }
  }
}
