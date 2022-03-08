import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import '../../../../config.dart';
import '../../../../routers.dart';
import '../../../log.dart';
import '../../../tools.dart';

class VideoMessageWidget extends StatelessWidget {
  final Map<String, dynamic> videoMessageMap;
  VideoMessageWidget(this.videoMessageMap);
  late final String? _videoUrlThumb;
  late final String? _videoUrl;
  late final String? _videoTime;
  late final int? _videoWidth;
  late final int? _videoHeight;

  void _init() {
    _videoUrlThumb = videoMessageMap["video_thum_url"] ?? "";
    _videoUrl = videoMessageMap["video_url"] ?? "";
    _videoTime = mediaTimeFormat(int.parse(videoMessageMap['time'] ?? "0"));
    _videoWidth = videoMessageMap["width"] ?? 1080;
    _videoHeight = videoMessageMap["height"] ?? 720;
    Log.green("_videoWidth _videoHeight $_videoWidth $_videoHeight");
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return _videoThumbMessageView();
  }

  Widget _videoThumbMessageView() {
    return Container(
        width: _videoWidth! >= _videoHeight! ? 150.0.w : 120.0.w,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: _videoUrlThumb!.contains("http")
              ? CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: _videoUrlThumb!,
                  placeholder: (context, url) {
                    return Center(
                      child: CupertinoActivityIndicator(radius: 10.0),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Center(
                      child: Icon(Icons.broken_image_outlined, size: 30),
                    );
                  },
                  imageBuilder: (context, imageProvider) {
                    return GestureDetector(
                        onTap: () => Routers.navigateTo("/video_play",
                            arg: {"videoUrl": _videoUrl}),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image(image: imageProvider, fit: BoxFit.cover),
                            Icon(Icons.play_circle_outline,
                                size: 45.0,
                                color: Flavors.colorInfo.subtitleColor),
                            Positioned(
                              bottom: 5,
                              right: 10,
                              child: Text("$_videoTime",
                                  style: Flavors.textStyles.chatVideoTimerText),
                            )
                          ],
                        ));
                  })
              : _videoUrlThumb != ""
                  ? GestureDetector(
                      onTap: () => Routers.navigateTo("/video_play",
                          arg: {"videoUrl": _videoUrl}),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.file(
                            File(_videoUrlThumb!),
                            fit: BoxFit.cover,
                          ),
                          Icon(Icons.play_circle_outline,
                              size: 45.0,
                              color: Flavors.colorInfo.subtitleColor),
                          Positioned(
                              bottom: 5,
                              right: 10,
                              child: Text("$_videoTime",
                                  style: Flavors.textStyles.chatVideoTimerText))
                        ],
                      ))
                  : Container(
                      child: Icon(Icons.cancel,
                          size: 35.0, color: Flavors.colorInfo.subtitleColor)),
        ));
  }
}
