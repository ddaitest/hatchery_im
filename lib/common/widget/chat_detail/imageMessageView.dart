import 'dart:io';
import 'package:hatchery_im/business/chat_detail/chat_detail_page.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hatchery_im/common/widget/imageDetail.dart';
import '../../../config.dart';
import '../../../routers.dart';

class ImageMessageWidget extends StatelessWidget {
  final Map<String, dynamic> imageMessageMap;
  final MessageBelongType messageBelongType;
  ImageMessageWidget(this.imageMessageMap, this.messageBelongType);
  bool _isShow = false;

  @override
  Widget build(BuildContext context) {
    return _imageMessageView();
  }

  Widget _imageMessageView() {
    String imageUrl = imageMessageMap["img_url"];
    if (imageUrl.contains("http")) {
      return GestureDetector(
          onTap: () => _isShow
              ? Routers.navigateTo('/imageDetail', arg: {"imageUrl": imageUrl})
              : null,
          child: CachedNetworkImage(
              width: 130.0.w,
              fit: BoxFit.cover,
              imageUrl: imageUrl,
              placeholder: (context, url) {
                _isShow = false;
                return Container(
                  // width: 150.0.w,
                  height: 180.0.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Flavors.colorInfo.mainBackGroundColor,
                  ),
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                );
              },
              errorWidget: (context, url, error) {
                _isShow = false;
                return Container(
                  width: 150.0.w,
                  height: 100.0.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Flavors.colorInfo.mainBackGroundColor,
                  ),
                  child: Center(
                    child: Icon(Icons.broken_image_outlined, size: 30),
                  ),
                );
              },
              imageBuilder: (context, imageProvider) {
                _isShow = true;
                return GestureDetector(
                  onTap: () => Routers.navigateTo('/imageDetail',
                      arg: {"image": imageProvider}),
                  child: Container(
                    constraints:
                        BoxConstraints(maxWidth: 130.0.w, maxHeight: 180.0.h),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image(image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                );
              }));
    } else {
      return GestureDetector(
          onTap: () => Routers.navigateTo('/imageDetail',
              arg: {"imageFile": File(imageUrl)}),
          child: Container(
            constraints: BoxConstraints(maxWidth: 130.0.w, maxHeight: 180.0.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: imageUrl != ""
                  ? Image.file(
                      File(imageUrl),
                      width: 130.0.w,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 130.0.w, child: Icon(Icons.cancel, size: 20.0)),
            ),
          ));
    }
  }
}
