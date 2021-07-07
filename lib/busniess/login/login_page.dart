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
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:hatchery_im/config.dart';

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

  Widget _bodyContainer() {
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
                        loginManager.isOTPLogin
                            ? _phoneNumInput(loginManager)
                            : _buildAccountTF(loginManager),
                        SizedBox(height: 30.0.h),
                        loginManager.isOTPLogin
                            ? _buildPhoneCodeTF(loginManager)
                            : _buildPasswordTF(loginManager),
                        _buildForgotPasswordBtn(loginManager),
                        _buildLoginBtn(loginManager),
                        SizedBox(height: 50.0.h),
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

  Widget _phoneNumInput(loginManager) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '手机号',
          style: Flavors.textStyles.loginNormalText,
        ),
        SizedBox(height: 10.0.h),
        Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Color(0xFF6CA8F1),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            height: 50.0.h,
            child: IntlPhoneField(
              searchText: '搜索国家',
              obscureText: false,
              countryCodeTextColor: Flavors.colorInfo.mainTextColor,
              dropDownArrowColor: Flavors.colorInfo.mainTextColor,
              style: Flavors.textStyles.loginNormalText,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly, //只输入数字
              ],
              decoration: InputDecoration(
                hintText: '输入手机号码',
                helperText: '',
                suffixText: '',
                counterText: '',
                // cursorColor: Flavors.colorInfo.subtitleColor,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(top: 6.0),
                hintMaxLines: 1,
                errorMaxLines: 1,
                hintStyle: Flavors.textStyles.hintTextText,
              ),
              initialCountryCode: 'CN',
              onChanged: (phone) {
                loginManager.phoneNumber = phone.number;
                loginManager.phoneNumberAreaCode = phone.countryCode;
              },
            )),
      ],
    );
  }

  Widget _buildPhoneCodeTF(loginManager) {
    print('countDown ${loginManager.countDown}');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
            // padding: const EdgeInsets.only(right: 40.0),
            width: Flavors.sizesInfo.screenWidth - 140.0.w,
            child: TextFormModel(
              '验证码',
              loginManager.phoneCodeController,
              TextInputType.number,
              Icons.mail,
              '请输入验证码',
              maxLength: 6,
              onlyNumber: true,
            )),
        Container(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: TextButton(
            child: loginManager.countDown == TimeConfig.OTP_CODE_RESEND
                ? Text(
                    "发送",
                    style: Flavors.textStyles.hintTextText,
                  )
                : Text(
                    "${loginManager.countDown.toString()}s",
                    style: Flavors.textStyles.hintTextText,
                  ),
            onPressed: loginManager.countDown == TimeConfig.OTP_CODE_RESEND
                ? () {
                    print(
                        "DEBUG=>sendPhoneNumText ${loginManager.phoneNumber}");
                    if (loginManager.phoneNumber != '') {
                      loginManager.sendOTP(loginManager.phoneNumber,
                          loginManager.phoneNumberAreaCode, 1);
                    } else {
                      print(
                          "DEBUG=>！！！！！sendPhoneNumText ${loginManager.phoneNumber}");
                      showToast('请输入手机号');
                    }
                  }
                : null,
          ),
        ),
      ],
    );
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

  Widget _buildForgotPasswordBtn(loginManager) {
    return Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => loginManager.setOTPLogin(),
              child: Text(
                loginManager.isOTPLogin ? '账号登录' : '手机验证码登录',
                style: Flavors.textStyles.hintTextText,
              ),
            ),
            TextButton(
              onPressed: () => print('Forgot Password Button Pressed'),
              child: Text(
                '忘记密码?',
                style: Flavors.textStyles.hintTextText,
              ),
            ),
          ],
        ));
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
