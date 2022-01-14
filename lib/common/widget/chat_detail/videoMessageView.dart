import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config.dart';

class VideoMessageWidget extends StatefulWidget {
  final Map<String, dynamic> videoMessageMap;
  final MessageBelongType messageBelongType;
  VideoMessageWidget(this.videoMessageMap, this.messageBelongType);
  @override
  VideoMessageState createState() => VideoMessageState();
}

class VideoMessageState extends State<VideoMessageWidget> {
  late BetterPlayerController _betterPlayerController;
  late BetterPlayerDataSource _betterPlayerDataSource;
  late String? videoUrl;

  @override
  void initState() {
    videoUrl = widget.videoMessageMap["video_url"] ?? "";
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
            aspectRatio: 16 / 9,
            fit: BoxFit.fill,
            autoPlay: false,
            looping: false,
            deviceOrientationsAfterFullScreen: []);
    _betterPlayerDataSource = BetterPlayerDataSource(
        videoUrl!.contains("http")
            ? BetterPlayerDataSourceType.network
            : BetterPlayerDataSourceType.file,
        videoUrl!,
        cacheConfiguration: BetterPlayerCacheConfiguration(useCache: true));
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(_betterPlayerDataSource);
    _betterPlayerController.controlsAlwaysVisible;
    super.initState();
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    videoUrl = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: 200.0.w, maxHeight: 150.0.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(controller: _betterPlayerController),
          ),
        ));
  }
}
