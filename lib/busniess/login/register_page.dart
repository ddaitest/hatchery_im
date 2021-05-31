import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/manager/registerManager.dart';
import 'package:hatchery_im/common/widget/login_page/textForm_model.dart';
import 'package:hatchery_im/routers.dart';

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
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
        appBar: AppBarFactory.backButton(''),
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
                              '注册账号',
                              style: Flavors.textStyles.loginMainTitleText,
                            ),
                            SizedBox(height: 20.0.h),
                            _avatarView(),
                            SizedBox(height: 10.0.h),
                            Text(
                              '添加照片',
                              style: Flavors.textStyles.loginNormalText,
                            ),
                            SizedBox(height: 20.0.h),
                            _buildAccountTF(registerManager),
                            SizedBox(height: 10.0.h),
                            _buildNickNameTF(registerManager),
                            SizedBox(height: 10.0.h),
                            _buildPasswordTF(registerManager),
                            _buildNextBtn(registerManager),
                            _buildSignInBtn(),
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

  Widget _buildAccountTF(registerManager) {
    return TextFormModel(
      '注册账号（登录用的）',
      registerManager.accountController,
      TextInputType.text,
      Icons.account_circle,
      '请输入账号',
    );
  }

  Widget _buildNickNameTF(registerManager) {
    return TextFormModel(
      '昵称（其他人看到的名字）',
      registerManager.nickNameController,
      TextInputType.text,
      Icons.switch_account,
      '请输入昵称',
    );
  }

  Widget _buildPasswordTF(registerManager) {
    return TextFormModel(
      '密码',
      registerManager.codeController,
      TextInputType.visiblePassword,
      Icons.lock,
      '请输入密码',
      hideText: true,
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
        onPressed: () => _nextStepBtn(registerManager),
        child: Text(
          '下一步',
          style: Flavors.textStyles.loginInButtonText,
        ),
      ),
    );
  }

  Widget _buildSignInBtn() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '已经注册? ',
              style: Flavors.textStyles.loginNormalText,
            ),
            TextSpan(text: '立即登录', style: Flavors.textStyles.loginLinkText),
          ],
        ),
      ),
    );
  }

  Widget _avatarView() {
    return Container(
      child: _imageFile.path == ''
          ? CircleAvatar(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Center(
                    child: IconButton(
                  onPressed: () => _showSheetMenu(context),
                  icon: Icon(Icons.photo_camera,
                      color: Flavors.colorInfo.mainColor, size: 35),
                )),
              ),
              maxRadius: 40,
            )
          : CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                  'https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3686156064,2328177349&fm=26&gp=0.jpg'),
              maxRadius: 40,
            ),
    );
  }

  _showSheetMenu(BuildContext context) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('选择图片'),
        actions: <Widget>[
          CupertinoActionSheetAction(
              child: const Text('相册'),
              onPressed: () => Navigator.pop(context, 'Gallery')),
          CupertinoActionSheetAction(
              child: const Text('照相机'),
              onPressed: () => Navigator.pop(context, 'Camera')),
        ],
        cancelButton: CupertinoActionSheetAction(
            child: const Text('取消'),
            // isDefaultAction: true,
            onPressed: () => Navigator.pop(context)),
      ),
    ).then((String? value) {
      if (value != null) {
        getImageBy(value);
      }
    });
  }

  Future getImageBy(String type) async {
    var s = ImageSource.camera;
    if (type == "Gallery") {
      s = ImageSource.gallery;
    }
    final pickedFile = await ImagePicker().getImage(source: s);
    if (pickedFile == null) {
      return null;
    }
    _imageFile = File(pickedFile.path);
    print("DDAI _image.lengthSync=${_imageFile.lengthSync()}");
    if (_imageFile.lengthSync() > 2080000) {
      compressionImage(_imageFile.path).then((value) {
        _uploadImage(_imageFile.path);
      });
    } else {
      _uploadImage(_imageFile.path);
    }
  }

  ///上传图片
  _uploadImage(String filePath) {
    App.manager<RegisterManager>().uploadImage(filePath).then((value) =>
        ScaffoldMessenger.of(App.navState.currentContext!)
            .showSnackBar(SnackBar(content: Text(value ? '上传成功' : "上传失败"))));
  }

  ///提交
  _nextStepBtn(registerManager) {
    print("${registerManager.accountController.text}");
    // Routers.navigateTo('/register_detail');
  }
}
