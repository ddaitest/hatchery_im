import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/common/widget/aboutAvatar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class QRCodeCardPage extends StatefulWidget {
  final String? avatarUrl, nickName, account, userID;
  QRCodeCardPage({this.avatarUrl, this.nickName, this.account, this.userID});
  @override
  QRCodeCardState createState() => QRCodeCardState();
}

class QRCodeCardState extends State<QRCodeCardPage> {
  Uint8List? _imageFile;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();
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
            controller: screenshotController,
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
                          netWorkAvatar(widget.avatarUrl, 30.0),
                          Container(
                            width: 15.0.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    widget.nickName!,
                                    style: Flavors
                                        .textStyles.qrCodeCardNickNameText,
                                  ),
                                ],
                              ),
                              Text(
                                '账号:  ${widget.account}',
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
                        child:
                            qrImageModel(key: 'userID', value: widget.userID!)),
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
    showCupertinoModalPopup<String>(
      context: App.navState.currentContext!,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
              child: Text('分享给其他人'),
              onPressed: () {
                Navigator.pop(context);
              }),
          CupertinoActionSheetAction(
              child: const Text('保存二维码'),
              onPressed: () {
                _saveQRImage();
                Navigator.pop(context);
              }),
        ],
        cancelButton: CupertinoActionSheetAction(
            child: const Text('取消'),
            isDefaultAction: false,
            onPressed: () => Navigator.pop(context)),
      ),
    );
  }

  void _saveQRImage() async {
    screenshotController.capture().then((Uint8List? image) async {
      //Capture Done
      saveImageToGallery(image!).then((value) {
        if (value) {
          showToast('二维码已保存到相册');
        } else {
          showToast('保存失败，没有本地存储权限');
        }
      });
    });
  }
}
