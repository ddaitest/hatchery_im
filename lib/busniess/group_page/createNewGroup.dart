import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hatchery_im/manager/newGroupsManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:cached_network_image/cached_network_image.dart';

class CreateNewGroupPage extends StatefulWidget {
  @override
  _CreateNewGroupState createState() => _CreateNewGroupState();
}

class _CreateNewGroupState extends State<CreateNewGroupPage> {
  File _imageFile = File('');
  @override
  Widget build(BuildContext context) {
    return _bodyContainer();
  }

  _bodyContainer() {
    return Scaffold(
        appBar: AppBarFactory.backButton('创建群组'),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              _topView(),
              Container(
                height: 20.0.h,
              ),
              // _middleView()
            ],
          ),
        ));
  }

  Widget _groupAvatarView() {
    return Selector<NewGroupsManager, String>(
      builder: (context, String value, child) {
        print("DEBUG=> imageUrl $value");
        return Container(
          padding: const EdgeInsets.only(top: 100.0),
          child: GestureDetector(
            onTap: () => _showSheetMenu(context),
            child: Container(
              child: value == '' ? _selectIconView() : _selectIconView(),
            ),
          ),
        );
      },
      selector: (BuildContext context, NewGroupsManager manager) {
        return manager.groupAvatarUrl;
      },
      shouldRebuild: (pre, next) => (pre != next),
    );
  }

  Widget _topView() {
    return Container(
      padding: const EdgeInsets.only(top: 150),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          _groupSettingView(),
          Positioned(top: -150.0, child: _groupAvatarView())
        ],
      ),
    );
  }

  Widget _groupSettingView() {
    return Container(
      width: Flavors.sizesInfo.screenWidth,
      height: 200.h,
      decoration: BoxDecoration(
        color: Flavors.colorInfo.mainBackGroundColor,
      ),
    );
  }

  Widget _selectIconView() {
    return CircleAvatar(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Center(
            child: Icon(
          Icons.photo_camera,
          color: Flavors.colorInfo.mainColor,
          size: 35,
        )),
      ),
      maxRadius: 40,
    );
  }

  _showSheetMenu(BuildContext context) {
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
    App.manager<NewGroupsManager>()
        .uploadImage(filePath)
        .then((value) => showToast(value ? '头像上传成功' : "头像上传失败"));
  }
}
