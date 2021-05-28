import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _isInputPhoneNumber = false;
  bool get isInputPhoneNumber => _isInputPhoneNumber;
  final GlobalKey<FormState> _sendAccountTextKey = GlobalKey<FormState>();
  final TextEditingController _sendAccountController = TextEditingController();
  final GlobalKey<FormState> _sendCodeTextKey = GlobalKey<FormState>();
  final TextEditingController _sendCodeController = TextEditingController();
  // GlobalKey<FormState> get sendTextKey => _sendAccountTextKey;
  // TextEditingController get sendText => _sendAccountText;

  @override
  Widget build(BuildContext context) {
    return _bodyContainer();
  }

  _bodyContainer() {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 100.0),
      child: SingleChildScrollView(
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
              child: Text(
                '登录注册表示同意用户协议、隐私条款',
                style: Flavors.textStyles.loginSubTitleText,
              ),
            ),
            TextFormField(
              key: _sendAccountTextKey,
              controller: _sendAccountController,
              keyboardType: TextInputType.name,
              maxLines: 1,
              maxLength: 15,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                labelText: "请输入账号",
                counterText: '',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                enabledBorder: OutlineInputBorder(
                  //未选中时候的颜色
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Flavors.colorInfo.subtitleColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  //未选中时候的颜色
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Flavors.colorInfo.mainColor,
                  ),
                ),
              ),
              // ignore: missing_return
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入您的账号';
                } else if (value.length > 15) {
                  return '账号格式不正确';
                }
                return null;
              },
            ),
            SizedBox(
              height: 19.0.h,
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Text('密码', style: Flavors.textStyles.loginInputTitleText),
            ),
            Container(
              height: 64.0,
              // padding: const EdgeInsets.only(left: 40, right: 40.0),
              child: TextFormField(
                key: _sendCodeTextKey,
                controller: _sendCodeController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                maxLines: 1,
                maxLength: 30,
                decoration: InputDecoration(
                  labelText: "请输入密码",
                  counterText: '',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding: const EdgeInsets.all(10.0),
                  enabledBorder: OutlineInputBorder(
                    //未选中时候的颜色
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Color.fromRGBO(47, 128, 237, 1),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    //未选中时候的颜色
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Color.fromRGBO(47, 128, 237, 1),
                    ),
                  ),
                ),
                // ignore: missing_return
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入您的密码';
                  }
                  return null;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 13.0),
                  child: RichText(
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: '没有注册? ',
                        style: Flavors.textStyles.loginInputTitleText,
                      ),
                      TextSpan(
                        text: '立即注册',
                        style: Flavors.textStyles.loginInputTitleText,
                      ),
                    ]),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.only(top: 13.0),
                    child: Text(
                      '忘记密码?',
                      style: Flavors.textStyles.loginLinkText,
                    )),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60.0,
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      return Color.fromRGBO(47, 128, 237, 1);
                      // //设置按下时的背景颜色
                      // if (states.contains(MaterialState.pressed)) {
                      //   return Colors.blue[200];
                      // }
                      // //默认不使用背景颜色
                      // return null;
                    }),
                  ),
                  child: Text(
                    "登录",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: isInputPhoneNumber == false
                      ? null
                      : () {
                          print("DEBUG => ${_sendCodeController.text}");
                        }),
            ),
          ],
        ),
      ),
    ));
//              Container(
//                  padding: const EdgeInsets.only(bottom: 0.0),
//                  child: Row(
//                    children: <Widget>[
//                      Text(
//                        '找回密码',
//                        style: TextStyle(
//                            color: Colors.blueAccent[400], fontSize: 13.0),
//                      ),
//                      Container(
//                          width: 40.0,
//                          height: 20.0,
//                          child: VerticalDivider(color: Colors.grey)),
//                      Text(
//                        '更多选项',
//                        style: TextStyle(
//                            color: Colors.blueAccent[400], fontSize: 13.0),
//                      ),
//                    ],
//                  ))
  }

  enableSubmitButton() {
    _isInputPhoneNumber = true;
  }

  disabledSubmitButton() {
    _isInputPhoneNumber = false;
  }
}
