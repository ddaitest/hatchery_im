import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/manager/register_manager/registerManager.dart';
import 'package:hatchery_im/common/widget/login_page/textForm_model.dart';
import 'package:hatchery_im/business/login/register/register_page_detail.dart';

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final manager = App.manager<RegisterManager>();
  File _imageFile = File('');

  @override
  Widget build(BuildContext context) {
    return _bodyContainer();
  }

  Widget _bodyContainer() {
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
                        _buildAccountTF(manager),
                        SizedBox(height: 10.0.h),
                        _buildNickNameTF(manager),
                        SizedBox(height: 10.0.h),
                        _buildPasswordTF(manager),
                        _buildNextBtn(manager),
                        _buildSignInBtn(),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
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
    return Selector<RegisterManager, String>(
      builder: (context, String value, child) {
        print("DEBUG=> imageUrl $value");
        return GestureDetector(
          onTap: () => _showSheetMenu(context),
          child: Container(
            child: value == ''
                ? _selectIconView()
                : CachedNetworkImage(
                    imageUrl: value,
                    placeholder: (context, url) => _selectIconView(),
                    imageBuilder: (context, imageProvider) {
                      return CircleAvatar(
                        backgroundImage: imageProvider,
                        maxRadius: 40,
                      );
                    }),
          ),
        );
      },
      selector: (BuildContext context, RegisterManager manager) {
        return manager.uploadUrl;
      },
      shouldRebuild: (pre, next) => (pre != next),
    );
  }

  Widget _selectIconView() {
    return CircleAvatar(
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
            child: Icon(
          Icons.photo_camera,
          color: Flavors.colorInfo.mainColor,
          size: 35,
        )),
      ),
      maxRadius: 40,
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
    App.manager<RegisterManager>()
        .uploadImage(filePath)
        .then((value) => showToast(value ? '头像上传成功' : "头像上传失败"));
  }

  ///提交
  _nextStepBtn(registerManager) {
    String account = registerManager.accountController.text;
    String nickName = registerManager.nickNameController.text;
    String password = registerManager.codeController.text;
    String imageUrl = registerManager.uploadUrl;
    print("$account $password");
    if (account != '' &&
        nickName != '' &&
        password != '' &&
        imageUrl != '' &&
        registerManager.uploadUrl != '') {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return RegisterPageDetail(account, nickName, password, imageUrl);
      }));
    } else {
      showToast('请填写完信息后点击下一步');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
