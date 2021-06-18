import 'dart:async';
import 'package:hatchery_im/busniess/chat_detail/chat_detail_page.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hatchery_im/common/widget/imageDetail.dart';

class ImageMessageWidget extends StatefulWidget {
  final String imageMessageUrl;
  final MessageBelongType messageBelongType;
  ImageMessageWidget(this.imageMessageUrl, this.messageBelongType);
  @override
  _ImageMessageWidgetState createState() => _ImageMessageWidgetState();
}

class _ImageMessageWidgetState extends State<ImageMessageWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _imageMessageView(widget.messageBelongType);
  }

  Widget _imageMessageView(MessageBelongType belongType) {
    return CachedNetworkImage(
        width: 130.0.w,
        fit: BoxFit.cover,
        imageUrl: widget.imageMessageUrl,
        // imageUrl: widget.friendsHistoryMessages.content,
        placeholder: (context, url) => Container(
              width: 150.0.w,
              height: 100.0.h,
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
                child: Icon(Icons.image_not_supported_outlined, size: 40),
              ),
            ),
        imageBuilder: (context, imageProvider) {
          return GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ImageDetailViewPage(image: imageProvider))),
            child: Container(
              constraints:
                  BoxConstraints(maxWidth: 130.0.w, maxHeight: 180.0.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
