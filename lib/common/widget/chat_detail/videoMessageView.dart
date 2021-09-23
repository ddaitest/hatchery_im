import 'package:hatchery_im/business/chat_detail/chat_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';
import '../../../config.dart';

class VideoMessageWidget extends StatefulWidget {
  final String videoMessageUrl;
  final MessageBelongType messageBelongType;
  VideoMessageWidget(this.videoMessageUrl, this.messageBelongType);
  @override
  _VideoMessageWidgetState createState() => _VideoMessageWidgetState();
}

class _VideoMessageWidgetState extends State<VideoMessageWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late FlickManager flickManager;
  @override
  void initState() {
    flickManager = FlickManager(
      autoPlay: false,
      videoPlayerController:
          VideoPlayerController.network(widget.videoMessageUrl),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _voiceMessageView(widget.messageBelongType);
  }

  Widget _voiceMessageView(MessageBelongType belongType) {
    return Container(
      constraints: BoxConstraints(maxWidth: 250.0.w, maxHeight: 180.0.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FlickVideoPlayer(
          flickManager: flickManager,
          flickVideoWithControls: FlickVideoWithControls(
              controls: FlickPortraitControls(), videoFit: BoxFit.cover),
        ),
      ),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }
}
