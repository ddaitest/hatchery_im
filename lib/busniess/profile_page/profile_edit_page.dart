import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hatchery_im/common/widget/login_page/textForm_model.dart';
import 'package:hatchery_im/manager/profileEditManager.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:hatchery_im/flavors/Flavors.dart';

class ProfileEditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileEditManager(),
      child: _bodyContainer(),
    );
  }

  _bodyContainer() {
    return Consumer(builder: (BuildContext context,
        ProfileEditManager profileEditManager, Widget? child) {
      return Scaffold(
          appBar: AppBarFactory.backButton('编辑资料'),
          body: Container(
            width: Flavors.sizesInfo.screenWidth,
            child: Column(
              children: <Widget>[
                // _topView(profileEditManager),
                _buildNickNameTF(profileEditManager),
                _buildEmailTF(profileEditManager),
                _buildNotesTF(profileEditManager),
                _buildAddressTF(profileEditManager),
                _buildFinishBtn(profileEditManager),
              ],
            ),
          ));
    });
  }

  Widget _buildNickNameTF(profileEditManager) {
    return TextFormModel(
      '昵称',
      profileEditManager.nickNameController,
      TextInputType.text,
      Icons.switch_account,
      '请输入昵称',
    );
  }

  Widget _buildEmailTF(profileEditManager) {
    return TextFormModel(
      '电子邮箱',
      profileEditManager.emailController,
      TextInputType.emailAddress,
      Icons.mail,
      '请输入电子邮箱地址',
    );
  }

  Widget _buildNotesTF(profileEditManager) {
    return TextFormModel(
      '个性签名',
      profileEditManager.notesController,
      TextInputType.text,
      Icons.article,
      '请输入个性签名',
    );
  }

  Widget _buildAddressTF(profileEditManager) {
    return TextFormModel(
      '地址',
      profileEditManager.addressController,
      TextInputType.text,
      Icons.location_on,
      '请输入地址',
    );
  }

  Widget _buildFinishBtn(profileEditManager) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
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
        onPressed: () => _submit(profileEditManager),
        child: Text(
          '保存',
          style: Flavors.textStyles.loginInButtonText,
        ),
      ),
    );
  }

  ///提交
  _submit(profileEditManager) {
    // // String loginName = widget.account;
    // // String nickName = widget.nickName;
    // // String avatarUrl = widget.imageUrl;
    // // String password = widget.password;
    // String notes = profileEditManager.notesController.text ?? '';
    // String phone = profileEditManager.phoneController.text ?? '';
    // String email = profileEditManager.emailController.text ?? '';
    // String address = profileEditManager.addressController.text ?? '';
    // if (loginName != '' &&
    //     nickName != '' &&
    //     avatarUrl != '' &&
    //     password != '') {
    //   print("test ${widget.account}");
    //   App.manager<profileEditManager>().submit(loginName, nickName, avatarUrl,
    //       password, notes, phone, email, address);
    // }
  }
}
