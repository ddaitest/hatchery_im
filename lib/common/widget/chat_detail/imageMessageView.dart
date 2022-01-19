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
import '../../log.dart';

class ImageMessageWidget extends StatelessWidget {
  final Map<String, dynamic> imageMessageMap;
  ImageMessageWidget(this.imageMessageMap);
  late final String? _imageUrl;
  late final int? _imageWidth;
  late final int? _imageHeight;

  void _init() {
    _imageUrl = imageMessageMap["img_url"] ?? "";
    _imageWidth = imageMessageMap["width"] ?? 1080;
    _imageHeight = imageMessageMap["height"] ?? 720;
    Log.red("_imageUrl $_imageUrl");
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return _imageMessageView();
  }

  Widget _imageMessageView() {
    return Container(
      width: _imageWidth! >= _imageHeight! ? 150.0.w : 120.0.w,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: AspectRatio(
            aspectRatio: _imageWidth! >= _imageHeight! ? 16 / 9 : 9 / 16,
            child: _imageUrl!.contains("http")
                ? CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: _imageUrl!,
                    placeholder: (context, url) {
                      return Container(
                        color: Flavors.colorInfo.mainBackGroundColor,
                        child: Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return Container(
                          color: Flavors.colorInfo.mainBackGroundColor,
                          child: Center(
                            child: Icon(Icons.broken_image_outlined, size: 30),
                          ));
                    },
                    imageBuilder: (context, imageProvider) {
                      return GestureDetector(
                          onTap: () => Routers.navigateTo('/imageDetail',
                              arg: {"imageUrl": _imageUrl!}),
                          child:
                              Image(image: imageProvider, fit: BoxFit.cover));
                    })
                : _imageUrl != ""
                    ? Image.file(
                        File(_imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Flavors.colorInfo.mainBackGroundColor,
                        child: Icon(Icons.cancel,
                            size: 35.0, color: Flavors.colorInfo.lightGrep)),
          )),
    );
  }
}
