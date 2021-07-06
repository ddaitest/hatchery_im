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
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/common/widget/login_page/textForm_model.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool nextKickBackExitApp = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: ChangeNotifierProvider(
          create: (context) => LoginManager(),
          child: _bodyContainer(),
        ));
  }

  Future<bool> _onWillPop() async {
    if (nextKickBackExitApp) {
      exitApp();
      return true;
    } else {
      showToast('再按一次退出APP');
      nextKickBackExitApp = true;
      Future.delayed(
        const Duration(seconds: 2),
        () => nextKickBackExitApp = false,
      );
      return false;
    }
  }

  _bodyContainer() {
    return Consumer(builder:
        (BuildContext context, LoginManager loginManager, Widget? child) {
      return Scaffold(
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
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 120.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '登录',
                          style: Flavors.textStyles.loginMainTitleText,
                        ),
                        SizedBox(height: 30.0.h),
                        _buildAccountTF(loginManager),
                        SizedBox(
                          height: 30.0.h,
                        ),
                        _buildPasswordTF(loginManager),
                        _buildForgotPasswordBtn(),
                        _buildLoginBtn(loginManager),
                        _buildSignInWithText(),
                        _buildSocialBtnRow(),
                        _buildSignupBtn(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAccountTF(loginManager) {
    return TextFormModel(
      '账号',
      loginManager.accountController,
      TextInputType.text,
      Icons.account_circle,
      '请输入账号',
    );
  }

  Widget _buildPasswordTF(loginManager) {
    return TextFormModel(
      '密码',
      loginManager.codeController,
      TextInputType.visiblePassword,
      Icons.lock,
      '请输入密码',
      hideText: true,
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        child: Text(
          '忘记密码?',
          style: Flavors.textStyles.loginLinkText,
        ),
      ),
    );
  }

  Widget _buildLoginBtn(loginManager) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
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
        onPressed: () => _submit(loginManager),
        child: Text(
          '登 录',
          style: Flavors.textStyles.loginInButtonText,
        ),
      ),
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- 或 -',
          style: Flavors.textStyles.loginNormalText,
        ),
        SizedBox(height: 20.0.h),
        Text(
          '用以下方式登录',
          style: Flavors.textStyles.loginNormalText,
        ),
      ],
    );
  }

  Widget _buildSocialBtn() {
    return GestureDetector(
      onTap: () => Routers.navigateTo('/phone_login'),
      child: Container(
        height: 55.0.h,
        width: 55.0.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Center(
            child: Icon(
          Icons.phone_android,
          size: 30.0,
          color: Colors.green,
        )),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: _buildSocialBtn(),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => Routers.navigateTo('/register'),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '没有账号? ',
              style: Flavors.textStyles.loginNormalText,
            ),
            TextSpan(text: '立即注册', style: Flavors.textStyles.loginLinkText),
          ],
        ),
      ),
    );
  }

  ///提交
  _submit(loginManager) {
    String account = loginManager.accountController.text;
    String password = loginManager.codeController.text;
    if (account != '' && password != '') {
      print("$account $password");
      App.manager<LoginManager>().submit(account, password);
    } else {
      showToast('账号或密码不能为空');
    }
  }
}
