import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/routers.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class OTPPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _bodyContainer();
  }

  Widget _bodyContainer() {
    String inputPhoneNumber = '';
    return Scaffold(
      appBar: AppBarFactory.backButton('',
          backGroundColor: Flavors.colorInfo.mainColor,
          backBtnColor: Flavors.colorInfo.mainBackGroundColor),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: <Widget>[
            mainBackGroundWidget(),
            Container(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 20.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      '手机号登录',
                      style: Flavors.textStyles.loginMainTitleText,
                    ),
                    SizedBox(height: 50.0.h),
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
                          autofocus: true,
                          style: Flavors.textStyles.loginNormalText,
                          decoration: InputDecoration(
                            hintText: '输入手机号码',
                            helperText: '',
                            suffixText: '',
                            counterText: '',
                            // cursorColor: Flavors.colorInfo.subtitleColor,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.only(top: 4.0),
                            hintMaxLines: 1,
                            errorMaxLines: 1,
                            hintStyle: Flavors.textStyles.hintTextText,
                          ),
                          initialCountryCode: 'CN',
                          onChanged: (phone) {
                            print(phone.completeNumber);
                            inputPhoneNumber = phone.completeNumber;
                          },
                        )),
                    SizedBox(height: 20.0.h),
                    _buildNextBtn(inputPhoneNumber),
                    SizedBox(height: 20.0.h),
                    _buildSignupBtn(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => Routers.navigateReplace('/register'),
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

  Widget _buildNextBtn(inputPhoneNumber) {
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
        onPressed: () => _nextStepBtn(inputPhoneNumber),
        child: Text(
          '下一步',
          style: Flavors.textStyles.loginInButtonText,
        ),
      ),
    );
  }

  ///下一步
  _nextStepBtn(String inputNum) {
    print(inputNum.replaceAll('+', ''));
    if (RegExp(r'^-?[0-9]+').hasMatch(inputNum.replaceAll('+', ''))) {
      // Navigator.push(context, MaterialPageRoute(builder: (context) {
      //   return RegisterPageDetail(account, nickName, password, imageUrl);
      // }));
    } else {
      showToast('请输入正确的手机号码');
    }
  }
}
