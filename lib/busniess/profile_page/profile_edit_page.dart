import 'package:flutter/material.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/manager/profileEditManager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileEditPage extends StatefulWidget {
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final manager = App.manager<ProfileEditManager>();
  @override
  void initState() {
    manager.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.backButton('编辑资料', actions: [
        Container(
            padding: const EdgeInsets.all(6.0),
            child: TextButton(
              onPressed: () {},
              child: Text(
                '保存',
                style: Flavors.textStyles.newGroupNextBtnText,
              ),
            )),
      ]),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120.0.w,
                      height: 120.0.h,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                          // todo 补充占位图
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                manager.imageUrl!,
                              ))),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40.0.h,
                          width: 40.0.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: Flavors.colorInfo.mainColor,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(height: 35.0.h),
              buildTextField(manager.nickNameController, "昵称", "请填写昵称"),
              buildTextField(manager.notesController, "个人简介", "请填写个人简介"),
              buildTextField(manager.addressController, "手机号", "请填写手机号"),
              buildTextField(manager.emailController, "写电子邮箱", "请填写电子邮箱"),
              buildTextField(manager.addressController, "地址", "请填写地址"),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController textEditingController,
      String labelText, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 3),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
        ),
      ),
    );
  }
}
