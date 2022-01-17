import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/flavors/Flavors.dart';

class VideoPlayPage extends StatefulWidget {
  final String videoUrl;
  VideoPlayPage(this.videoUrl);
  @override
  VideoPlayState createState() => VideoPlayState();
}

class VideoPlayState extends State<VideoPlayPage> {
  late BetterPlayerController _betterPlayerController;
  late BetterPlayerDataSource _betterPlayerDataSource;

  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
            aspectRatio: 9 / 16,
            fit: BoxFit.cover,
            autoPlay: true,
            looping: true);
    _betterPlayerDataSource = BetterPlayerDataSource(
        widget.videoUrl.contains("http")
            ? BetterPlayerDataSourceType.network
            : BetterPlayerDataSourceType.file,
        widget.videoUrl,
        cacheConfiguration: BetterPlayerCacheConfiguration(useCache: true));
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setBetterPlayerControlsConfiguration(
        BetterPlayerControlsConfiguration(
            showControlsOnInitialize: false,
            enableRetry: false,
            enableSubtitles: false,
            enablePlaybackSpeed: false,
            enablePip: false,
            enableOverflowMenu: false,
            enableQualities: false,
            enableSkips: false,
            enableAudioTracks: false));
    _betterPlayerController.setupDataSource(_betterPlayerDataSource);
    _betterPlayerController.addEventsListener((p0) {
      if (_betterPlayerController.isFullScreen) {
        _betterPlayerController.setBetterPlayerControlsConfiguration(
            BetterPlayerControlsConfiguration(
                showControlsOnInitialize: false,
                enableRetry: false,
                enableSubtitles: false,
                enablePlaybackSpeed: false,
                enablePip: false,
                enableOverflowMenu: false,
                enableQualities: false,
                enableSkips: false,
                enableAudioTracks: false));
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(
            padding: const EdgeInsets.all(20.0),
            icon: Icon(
              Icons.arrow_back,
              size: 30.0,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: SafeArea(
          child: _videoPlayWidget(),
        ));
  }

  Widget _videoPlayWidget() {
    return GestureDetector(
      onTap: () => _betterPlayerController.enterFullScreen(),
      child: Container(
          width: Flavors.sizesInfo.screenWidth,
          height: Flavors.sizesInfo.screenHeight,
          child: BetterPlayer(controller: _betterPlayerController)),
    );
  }
}
