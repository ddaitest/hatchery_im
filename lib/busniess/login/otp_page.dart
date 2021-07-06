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
import 'package:hatchery_im/manager/registerManager.dart';
import 'package:hatchery_im/common/widget/login_page/textForm_model.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/busniess/login/register_page_detail.dart';
import 'package:image_crop/image_crop.dart';

class OTPPage extends StatefulWidget {
  @override
  OTPPageState createState() => OTPPageState();
}

class OTPPageState extends State<OTPPage> {
  final manager = App.manager<RegisterManager>();
  File _imageFile = File('');

  @override
  Widget build(BuildContext context) {
    return _bodyContainer();
  }

  _bodyContainer() {
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
                padding: const EdgeInsets.only(top: 50.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: ListTile(
                            leading: Text(
                              '手机号登录',
                              style: TextStyle(fontSize: 23.0),
                            ),
                          )),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 45.0,
                              child: ListTile(
                                leading: Text('国家/地区    中国大陆',
                                    style: TextStyle(fontSize: 15.0)),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                  size: 15.0,
                                ),
                              ),
                            ),
                            Divider(
                              height: 0.0,
                              indent: 20.0,
                              endIndent: 20.0,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 15.0),
                              height: 45.0,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 5.0, right: 35.0),
                                    child: Text(
                                      '+86',
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                  ),
                                  Container(
                                      height: 50,
                                      child:
                                          VerticalDivider(color: Colors.grey)),
                                  Container(
                                    padding: const EdgeInsets.all(4.0),
                                    width: 200.0,
                                    child: TextFormField(
                                      // key: loginManager.sendTextKey,
                                      // controller: loginManager.sendText,
                                      keyboardType: TextInputType.number,
                                      maxLength: 11,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          counterText: "",
                                          hintText: '请填写手机号码',
                                          hintStyle: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.grey)),
                                      onChanged: (inputText) {
                                        if (inputText.isEmpty) {
                                        }
                                        // loginManager.disabledSubmitButton();
                                        else {}
                                        // loginManager.enableSubmitButton();
                                      },
                                      // ignore: missing_return
                                      validator: (phoneValue) {
                                        RegExp reg = RegExp(r'^\d{11}$');
                                        if (!reg.hasMatch(phoneValue!)) {
                                          return '请输入正确的手机号码';
                                        }
                                      },
                                      inputFormatters: <TextInputFormatter>[
                                        WhitelistingTextInputFormatter
                                            .digitsOnly, //只输入数字
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              height: 0.0,
                              indent: 20.0,
                              endIndent: 20.0,
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: ListTile(
                                leading: Text(
                                  '用微信号/QQ号/邮箱登录',
                                  style: TextStyle(
                                      color: Color(0xFF576B95), fontSize: 13.0),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 30.0,
                              height: 60.0,
                              padding: const EdgeInsets.only(top: 20.0),
                              child: RaisedButton(
                                  disabledColor: Colors.grey[200],
                                  textColor: Colors.white,
                                  elevation: 0.0,
                                  color: Color(0xFF46c01b),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    "登录",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  onPressed: () {}),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextBtn() {
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
        onPressed: () => null,
        child: Text(
          '登录',
          style: Flavors.textStyles.loginInButtonText,
        ),
      ),
    );
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
