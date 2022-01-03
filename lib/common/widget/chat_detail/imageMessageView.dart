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
  final String imageMessageUrl;
  final MessageBelongType messageBelongType;
  ImageMessageWidget(this.imageMessageUrl, this.messageBelongType);

  @override
  Widget build(BuildContext context) {
    return _imageMessageView();
  }

  Widget _imageMessageView() {
    if (imageMessageUrl.contains("http")) {
      return GestureDetector(
          onTap: () => Routers.navigateTo('/imageDetail',
              arg: {"imageUrl": imageMessageUrl}),
          child: CachedNetworkImage(
              width: 130.0.w,
              fit: BoxFit.cover,
              imageUrl: imageMessageUrl,
              placeholder: (context, url) => Container(
                    // width: 150.0.w,
                    height: 180.0.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Flavors.colorInfo.mainBackGroundColor,
                    ),
                    child: Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  ),
              errorWidget: (context, url, error) => Container(
                    width: 150.0.w,
                    height: 100.0.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Flavors.colorInfo.mainBackGroundColor,
                    ),
                    child: Center(
                      child: Icon(Icons.broken_image_outlined, size: 30),
                    ),
                  ),
              imageBuilder: (context, imageProvider) {
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
              arg: {"imageFile": File(imageMessageUrl)}),
          child: Container(
            constraints: BoxConstraints(maxWidth: 130.0.w, maxHeight: 180.0.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: imageMessageUrl != ""
                  ? Image.file(
                      File(imageMessageUrl),
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
