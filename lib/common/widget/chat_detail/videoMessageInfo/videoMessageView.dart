import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import '../../../../config.dart';
import '../../../../routers.dart';
import '../../../tools.dart';

class VideoMessageWidget extends StatefulWidget {
  final Map<String, dynamic> videoMessageMap;
  final MessageBelongType messageBelongType;
  VideoMessageWidget(this.videoMessageMap, this.messageBelongType);
  @override
  VideoMessageState createState() => VideoMessageState();
}

class VideoMessageState extends State<VideoMessageWidget> {
  bool _canClick = false;
  String? _videoUrlThumb;
  String? _videoTime;
  int? _videoWidth;
  int? _videoHeight;
  @override
  void initState() {
    _videoUrlThumb = widget.videoMessageMap["video_thum_url"] ?? "";
    _videoTime =
        videoTimeFormat(int.parse(widget.videoMessageMap['time'] ?? "0"));
    _videoWidth = widget.videoMessageMap["width"] ?? 1080;
    _videoHeight = widget.videoMessageMap["height"] ?? 720;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _videoThumbMessageView();
  }

  Widget _videoThumbMessageView() {
    return GestureDetector(
      onTap: () => _canClick
          ? Routers.navigateTo("/video_play",
              arg: {"videoUrl": widget.videoMessageMap["video_url"]})
          : null,
      child: Container(
          width: _videoWidth! >= _videoHeight! ? 150.0.w : 120.0.w,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(
              aspectRatio: _videoWidth! >= _videoHeight! ? 16 / 9 : 9 / 16,
              child: _videoUrlThumb!.contains("http")
                  ? CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: _videoUrlThumb!,
                      placeholder: (context, url) {
                        _canClick = false;
                        return Center(
                          child: CupertinoActivityIndicator(radius: 10.0),
                        );
                      },
                      errorWidget: (context, url, error) {
                        _canClick = false;
                        return Center(
                          child: Icon(Icons.broken_image_outlined, size: 30),
                        );
                      },
                      imageBuilder: (context, imageProvider) {
                        _canClick = true;
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Image(image: imageProvider, fit: BoxFit.cover),
                            Icon(Icons.play_circle_outline,
                                size: 45.0, color: Flavors.colorInfo.lightGrep),
                            Positioned(
                              bottom: 5,
                              right: 10,
                              child: Text("$_videoTime",
                                  style: Flavors.textStyles.chatVideoTimerText),
                            )
                          ],
                        );
                      })
                  : _videoUrlThumb != ""
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.file(
                              File(_videoUrlThumb!),
                              fit: BoxFit.cover,
                            ),
                            Icon(Icons.play_circle_outline,
                                size: 45.0, color: Flavors.colorInfo.lightGrep),
                            Positioned(
                                bottom: 5,
                                right: 10,
                                child: Text("$_videoTime",
                                    style:
                                        Flavors.textStyles.chatVideoTimerText))
                          ],
                        )
                      : Container(
                          child: Icon(Icons.cancel,
                              size: 35.0, color: Flavors.colorInfo.lightGrep)),
            ),
          )),
    );
  }
}
