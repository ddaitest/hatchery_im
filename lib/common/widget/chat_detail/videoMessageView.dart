import 'package:hatchery_im/business/chat_detail/chat_detail_page.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';
import '../../../config.dart';

class VideoMessageWidget extends StatelessWidget {
  final Map<String, dynamic> videoMessageMap;
  final MessageBelongType messageBelongType;
  VideoMessageWidget(this.videoMessageMap, this.messageBelongType);

  @override
  Widget build(BuildContext context) {
    FlickManager? flickManager;
    String videoUrl = "";
    videoUrl = videoMessageMap["video_url"];
    flickManager = FlickManager(
      autoPlay: false,
      videoPlayerController: videoUrl.contains("http")
          ? VideoPlayerController.network(videoUrl)
          : VideoPlayerController.file(File(videoUrl)),
    );
    return Container(
      constraints: BoxConstraints(maxWidth: 200.0.w, maxHeight: 150.0.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FlickVideoPlayer(
          flickManager: flickManager,
          flickVideoWithControls: FlickVideoWithControls(
              controls: FlickPortraitControls(), videoFit: BoxFit.fitHeight),
        ),
      ),
    );
  }
}
