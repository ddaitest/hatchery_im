import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/manager/userCentre.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/common/widget/aboutAvatar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

import '../../config.dart';
import '../../routers.dart';

class QRCodeCardPage extends StatelessWidget {
  //Create an instance of ScreenshotController
  final ScreenshotController _screenshotController = ScreenshotController();
  final MyProfile? _myProfileData = UserCentre.getInfo();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarFactory.backButton('二维码名片', actions: [
          IconButton(
              onPressed: () => _showSheetMenu(),
              icon: Icon(Icons.more_vert,
                  size: 25, color: Flavors.colorInfo.darkGreyColor))
        ]),
        body: _bodyContainer());
  }

  _bodyContainer() {
    return Container(
        color: Colors.grey[200],
        child: Center(
          child: Screenshot(
            controller: _screenshotController,
            child: Container(
              width: Flavors.sizesInfo.screenWidth - 60.0.w,
              height: Flavors.sizesInfo.screenHeight - 250.0.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular((10.0)),
                color: Flavors.colorInfo.mainBackGroundColor,
              ),
              child: Container(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          netWorkAvatar(_myProfileData?.icon ?? "", 30.0),
                          Container(
                            width: 15.0.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    _myProfileData?.nickName ?? "",
                                    style: Flavors
                                        .textStyles.qrCodeCardNickNameText,
                                  ),
                                ],
                              ),
                              Text(
                                'ID:  ${_myProfileData?.userID ?? ""}',
                                style:
                                    Flavors.textStyles.qrCodeCardSubtitleText,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.all(10.0),
                        child: qrImageModel(
                            key: 'userID',
                            value: _myProfileData?.userID ?? "")),
                    Container(
                      child: Text(
                        '扫一扫上面的二维码图案添加我为好友',
                        style: Flavors.textStyles.qrCodeCardSubtitleText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  _showSheetMenu() {
    Map<String, dynamic> content = {
      "nick": "${_myProfileData?.nickName ?? ""}",
      "icon": "${_myProfileData?.icon ?? ""}",
      "user_id": "${_myProfileData?.userID ?? ""}"
    };
    showCupertinoModalPopup<String>(
      context: App.navState.currentContext!,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
              child: Text('分享给其他人',
                  style: Flavors.textStyles.qrCodeCardNickNameText),
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(App.navState.currentContext!);
                Routers.navigateTo('/select_contacts_model', arg: {
                  'titleText': '分享名片',
                  'tipsText': '请至少选择一名好友',
                  'leastSelected': 1,
                  'nextPageBtnText': '分享',
                  'selectContactsType': SelectContactsType.Share,
                  'contentType': 'CARD',
                  'shareMessageContent': content,
                  'groupMembersFriendId': ['']
                });
              }),
          CupertinoActionSheetAction(
              child: Text('保存二维码',
                  style: Flavors.textStyles.qrCodeCardNickNameText),
              isDefaultAction: true,
              onPressed: () {
                _saveQRImage();
                Navigator.pop(App.navState.currentContext!);
              }),
        ],
        cancelButton: CupertinoActionSheetAction(
            child: const Text('取消'),
            isDefaultAction: false,
            onPressed: () => Navigator.pop(App.navState.currentContext!)),
      ),
    );
  }

  void _saveQRImage() async {
    _screenshotController.capture().then((Uint8List? image) async {
      //Capture Done
      saveImageToGallery(image!).then((value) {
        if (value) {
          showToast('二维码已保存到相册');
        } else {
          showToast('保存失败，没有存储权限');
        }
      });
    });
  }
}
