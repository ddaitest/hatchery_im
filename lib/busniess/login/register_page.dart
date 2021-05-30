import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/manager/registerManager.dart';
import 'package:hatchery_im/common/widget/login_page/textForm_model.dart';

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  RegisterManager _registerManager = RegisterManager();

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Text(
                        '账号注册',
                        style: Flavors.textStyles.loginMainTitleText,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 12.0),
                      child: Text(
                        '填写详细注册资料来创建账号',
                        style: Flavors.textStyles.loginSubTitleText,
                      ),
                    ),
                    TextFormModel(
                      registerManager.accountController,
                      '账号',
                    ),
                    SizedBox(
                      height: 19.0.h,
                    ),
                    TextFormModel(
                      registerManager.codeController,
                      '密码',
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
                              // //设置按下时的背景颜色
                              // if (states.contains(MaterialState.pressed)) {
                              //   return Colors.blue[200];
                              // }
                              // //默认不使用背景颜色
                              // return null;
                            }),
                          ),
                          child: Text(
                            "下一步",
                            style: Flavors.textStyles.loginInButtonText,
                          ),
                          onPressed: () {
                            print("DEBUG => ");
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ));
    });
  }
}
