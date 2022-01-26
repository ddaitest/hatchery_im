import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/manager/login_manager/loginManager.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/common/widget/login_page/textForm_model.dart';
import 'package:hatchery_im/config.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool nextKickBackExitApp = false;
  final manager = App.manager<LoginManager>();

  @override
  void initState() {
    manager.init();
    super.initState();
  }

  @override
  void dispose() {
    manager.accountController.clear();
    manager.codeController.clear();
    manager.phoneCodeController.clear();
    manager.phoneNumController.clear();
    manager.countDown = TimeConfig.OTP_CODE_RESEND;
    manager.countDownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: _onWillPop, child: _bodyContainer());
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
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              mainBackGroundWidget(),
              _mainContainerView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mainContainerView() {
    return Selector<LoginManager, bool>(
      builder: (BuildContext context, bool value, Widget? child) {
        return Container(
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
                _accountCell(value),
                SizedBox(height: 30.0.h),
                _codeCell(value),
                _buildForgotPasswordBtn(),
                _buildLoginBtn(value),
                SizedBox(height: 50.0.h),
                _buildSignupBtn(),
              ],
            ),
          ),
        );
      },
      selector: (BuildContext context, LoginManager loginManager) {
        return loginManager.isOTPLogin;
      },
      shouldRebuild: (pre, next) => (pre != next),
    );
  }

  Widget _accountCell(bool isOTPLogin) {
    return isOTPLogin ? _buildPhoneNumberTF() : _buildAccountTF();
  }

  Widget _codeCell(bool isOTPLogin) {
    return isOTPLogin ? _buildPhoneCodeTF() : _buildPasswordTF();
  }

  Widget _buildPhoneNumberTF() {
    return Container(
        width: Flavors.sizesInfo.screenWidth,
        child: TextFormModel(
          '手机号',
          manager.phoneNumController,
          TextInputType.number,
          CountryCodePicker(
            onInit: (phone) => manager.phoneNumberAreaCode =
                phone?.dialCode!.substring(1) ?? "86",
            onChanged: (phone) => manager.phoneNumberAreaCode =
                phone.dialCode?.substring(1) ?? "86",
            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
            padding: const EdgeInsets.only(
                left: 8.0, right: 4.0, bottom: 8.0, top: 8.0),
            textStyle: Flavors.textStyles.hintTextText,
            initialSelection: 'CN',
            favorite: ['+86', 'CN'],
            countryFilter: ['CN', 'US', 'SG'],
            // optional. Shows only country name and flag
            showCountryOnly: false,
            // optional. Shows only country name and flag when popup is closed.
            showOnlyCountryWhenClosed: false,
            // optional. aligns the flag and the Text left
            alignLeft: false,
          ),
          '请输入手机号',
          suffixWidget: null,
          maxLength: 15,
          onlyNumber: true,
        ));
  }

  Widget _buildPhoneCodeTF() {
    return Container(
        width: Flavors.sizesInfo.screenWidth,
        child: TextFormModel(
          '验证码',
          manager.phoneCodeController,
          TextInputType.number,
          Icon(
            Icons.mail,
            color: Colors.white,
          ),
          '请输入验证码',
          suffixWidget: _countDownTimeView(),
          maxLength: 6,
          onlyNumber: true,
        ));
  }

  Widget _countDownTimeView() {
    return Selector<LoginManager, int>(
      builder: (BuildContext context, int value, Widget? child) {
        return Container(
            padding: const EdgeInsets.only(right: 5.0, bottom: 5.0),
            child: TextButton(
                child: Text(
                  value == TimeConfig.OTP_CODE_RESEND ? "获取验证码" : "$value s",
                  style: Flavors.textStyles.otpText,
                ),
                onPressed: value == TimeConfig.OTP_CODE_RESEND
                    ? () {
                        print(
                            "DEBUG=>sendPhoneNumText ${manager.phoneNumController.text}");
                        if (manager.phoneNumController.text != '') {
                          manager.sendOTP(manager.phoneNumController.text,
                              manager.phoneNumberAreaCode, 1);
                        } else {
                          showToast('请输入手机号');
                        }
                      }
                    : () {}));
      },
      selector: (BuildContext context, LoginManager loginManager) {
        return loginManager.countDown;
      },
      shouldRebuild: (pre, next) => (pre != next),
    );
  }

  Widget _buildAccountTF() {
    return TextFormModel(
      '账号',
      manager.accountController,
      TextInputType.text,
      Icon(
        Icons.account_circle,
        color: Colors.white,
      ),
      '请输入账号',
    );
  }

  Widget _buildPasswordTF() {
    return TextFormModel(
      '密码',
      manager.codeController,
      TextInputType.visiblePassword,
      Icon(
        Icons.lock,
        color: Colors.white,
      ),
      '请输入密码',
      hideText: true,
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => manager.setOTPLogin(),
              child: Text(
                manager.isOTPLogin ? '账号登录' : '手机验证码登录',
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

  Widget _buildLoginBtn(bool isOTPLogin) {
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
        onPressed: () => isOTPLogin ? _phoneCodeSubmit() : _submit(),
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
  void _submit() {
    String account = manager.accountController.text;
    String password = manager.codeController.text;
    if (account != '' && password != '') {
      print("$account $password");
      manager.submit(account, password);
    } else {
      showToast('账号或密码不能为空');
    }
  }

  ///提交
  void _phoneCodeSubmit() {
    String phoneNum = manager.phoneNumController.text;
    String phoneNumberAreaCode = manager.phoneNumberAreaCode;
    String phoneCode = manager.phoneCodeController.text;
    print("DEBUG=> $phoneNum");
    if (phoneNum == '') {
      showToast('手机号不能为空');
    } else if (phoneCode == '') {
      showToast('验证码不能为空');
    } else {
      FocusScope.of(App.navState.currentContext!).requestFocus(FocusNode());
      manager.phoneSubmit(phoneNum, phoneNumberAreaCode, phoneCode);
    }
  }
}
