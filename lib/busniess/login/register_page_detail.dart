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
          appBar: AppBarFactory.backButton(''),
          body: Container(
            width: Flavors.sizesInfo.screenWidth,
            height: Flavors.sizesInfo.screenHeight,
            color: Flavors.colorInfo.mainBackGroundColor,
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
            child: SingleChildScrollView(
              child: Form(
                key: registerManager.registerInputKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Container(
                    //   padding: const EdgeInsets.only(bottom: 2.0),
                    //   child: Text(
                    //     '账号注册',
                    //     style: Flavors.textStyles.loginMainTitleText,
                    //   ),
                    // ),
                    // Container(
                    //   padding: const EdgeInsets.only(top: 10.0, bottom: 12.0),
                    //   child: Text(
                    //     '填写详细注册资料来创建账号',
                    //     style: Flavors.textStyles.loginSubTitleText,
                    //   ),
                    // ),
                    TextFormModel(
                      registerManager.accountController,
                      '昵称(其他人看到的名字)',
                    ),
                    SizedBox(
                      height: 19.0.h,
                    ),
                    TextFormModel(
                      registerManager.codeController,
                      '手机号',
                    ),
                    SizedBox(
                      height: 19.0.h,
                    ),
                    TextFormModel(
                      registerManager.codeController,
                      '地址',
                    ),
                    SizedBox(
                      height: 19.0.h,
                    ),
                    TextFormModel(
                      registerManager.codeController,
                      '电子邮箱',
                      hideText: true,
                    ),
                    SizedBox(
                      height: 19.0.h,
                    ),
                    TextFormModel(
                      registerManager.codeController,
                      '个人签名',
                      hideText: true,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                      child: RichText(
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: '注册账号表示同意',
                            style: Flavors.textStyles.loginSubTitleText,
                          ),
                          TextSpan(
                            text: '用户协议、隐私条款',
                            style: Flavors.textStyles.loginLinkText,
                          ),
                        ]),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith((states) {
                              return Flavors.colorInfo.mainColor;
                            }),
                          ),
                          child: Text(
                            "完成注册",
                            style: Flavors.textStyles.loginInButtonText,
                          ),
                          onPressed: () {}),
                    ),
                  ],
                ),
              ),
            ),
          ));
    });
  }

  _avatarView() {
    return CircleAvatar(
      child: CachedNetworkImage(
          imageUrl:
              'https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3686156064,2328177349&fm=26&gp=0.jpg'),
      maxRadius: 30,
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
}
