import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/manager/profileEditManager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/widget/aboutAvatar.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hatchery_im/common/widget/profile/profile_menu_item.dart';
import 'package:hatchery_im/busniess/profile_page/edit_profile/edit_detail.dart';

class ProfileEditPage extends StatefulWidget {
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final manager = App.manager<ProfileEditManager>();
  File _imageFile = File('');
  @override
  void initState() {
    manager.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarFactory.backButton('编辑资料'),
        body: Container(
          padding: EdgeInsets.only(left: 12, top: 25, right: 12),
          child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () => _showSheetMenu(),
                      child: Center(
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 4,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.1),
                                      offset: Offset(0, 10))
                                ],
                                shape: BoxShape.circle,
                              ),
                              child: _avatarView(),
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
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
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
                      )),
                  SizedBox(height: 65.0.h),
                  _listInfo(),
                ],
              )),
        ));
  }

  Widget _avatarView() {
    return Selector<ProfileEditManager, String>(
        builder: (BuildContext context, String value, Widget? child) {
          return netWorkAvatar(value, 60.0);
        },
        selector:
            (BuildContext context, ProfileEditManager profileEditManager) {
          return profileEditManager.imageUrl;
        },
        shouldRebuild: (pre, next) => (pre != next));
  }

  Widget _listInfo() {
    return Selector<ProfileEditManager, MyProfile>(
        builder: (BuildContext context, MyProfile value, Widget? child) {
          return ListView(
            shrinkWrap: true,
            children: [
              _dataCellView("昵称", value.nickName ?? ''),
              _dataCellView("个人简介", value.notes ?? '无'),
              _dataCellView("手机号", value.phone ?? '无',
                  isTap: value.phone != '' ? false : true),
              _dataCellView("电子邮箱", value.email ?? '无'),
              _dataCellView("地址", value.address ?? '无'),
            ],
          );
        },
        selector:
            (BuildContext context, ProfileEditManager profileEditManager) {
          return profileEditManager.myProfileData!;
        },
        shouldRebuild: (pre, next) => (pre != next));
  }

  Widget _dataCellView(String title, String trailingText, {bool isTap = true}) {
    return GestureDetector(
      onTap: () => isTap
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProfileEditDetailPage(
                        '$title',
                        trailingText,
                        '$title',
                        maxLength: title == '个人简介' || title == '地址' ? 60 : 20,
                        maxLine: title == '个人简介' || title == '地址' ? 4 : 2,
                        onlyNumber: title == '手机号' ? true : false,
                      ))).then((value) => value ? manager.refreshData() : null)
          : null,
      child: ProfileEditMenuItem(
        title,
        trailingText: trailingText,
        showForwardIcon: isTap ? true : false,
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

  _showSheetMenu() {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('选择图片'),
        actions: <Widget>[
          CupertinoActionSheetAction(
              child: const Text('相册'),
              onPressed: () => Navigator.pop(context, 'Gallery')),
          CupertinoActionSheetAction(
              child: const Text('照相机'),
              onPressed: () => Navigator.pop(context, 'Camera')),
        ],
        cancelButton: CupertinoActionSheetAction(
            child: const Text('取消'),
            // isDefaultAction: true,
            onPressed: () => Navigator.pop(context)),
      ),
    ).then((String? value) {
      if (value != null) {
        getImageBy(value);
      }
    });
  }

  Future getImageBy(String type) async {
    var s = ImageSource.camera;
    if (type == "Gallery") {
      s = ImageSource.gallery;
    }
    final pickedFile = await ImagePicker().getImage(source: s);
    if (pickedFile == null) {
      return null;
    }
    _imageFile = File(pickedFile.path);
    print("DDAI _image.lengthSync=${_imageFile.lengthSync()}");
    if (_imageFile.lengthSync() > 2080000) {
      compressionImage(_imageFile.path).then((value) {
        _uploadImage(_imageFile.path);
      });
    } else {
      _uploadImage(_imageFile.path);
    }
  }

  ///上传图片
  _uploadImage(String filePath) {
    App.manager<ProfileEditManager>()
        .uploadImage(filePath)
        .then((value) => showToast(value ? '头像上传成功' : "头像上传失败"));
  }
}
