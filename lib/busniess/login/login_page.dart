import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/manager/loginManager.dart';
import 'package:hatchery_im/common/widget/login_page/textForm_model.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  LoginManager _loginManager = LoginManager();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _loginManager,
      child: _bodyContainer(),
    );
  }

  _bodyContainer() {
    return Consumer(builder:
        (BuildContext context, LoginManager loginManager, Widget? child) {
      return Scaffold(
          body: Container(
        width: Flavors.sizesInfo.screenWidth,
        height: Flavors.sizesInfo.screenHeight,
        color: Flavors.colorInfo.mainBackGroundColor,
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 200.0),
        child: SingleChildScrollView(
            child: Form(
          key: loginManager.loginInputKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(
                  '登录',
                  style: Flavors.textStyles.loginMainTitleText,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: RichText(
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                      text: '登录注册账号表示同意',
                      style: Flavors.textStyles.loginSubTitleText,
                    ),
                    TextSpan(
                      text: '用户协议、隐私条款',
                      style: Flavors.textStyles.loginLinkText,
                    ),
                  ]),
                ),
              ),
              TextFormModel(loginManager.accountController, '账号'),
              SizedBox(
                height: 19.0.h,
              ),
              TextFormModel(
                loginManager.codeController,
                '密码',
                hideText: true,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Routers.navigateTo('/register'),
                    child: Container(
                      padding: const EdgeInsets.only(top: 13.0),
                      child: RichText(
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: '没有注册? ',
                            style: Flavors.textStyles.loginSubTitleText,
                          ),
                          TextSpan(
                            text: '立即注册',
                            style: Flavors.textStyles.loginLinkText,
                          ),
                        ]),
                      ),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.only(top: 13.0),
                      child: Text(
                        '手机验证码登录',
                        style: Flavors.textStyles.loginLinkText,
                      )),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: 20.0),
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
                      "登 录",
                      style: Flavors.textStyles.loginInButtonText,
                    ),
                    onPressed: () {
                      submit(loginManager);
                      print("DEBUG => ");
                    }),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.all(10),
                child: TextButton(
                    onPressed: () {},
                    child:
                        Text("忘记密码?", style: Flavors.textStyles.loginLinkText)),
              )
            ],
          ),
        )),
      ));
    });
  }

  ///提交
  submit(LoginManager loginManager) {
    if (loginManager.loginInputKey.currentState!.validate()) {
      var account = loginManager.accountController.text;
      var password = loginManager.codeController.text;
      App.manager<LoginManager>().submit(account, password);
    }
  }
}
