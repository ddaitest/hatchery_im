import 'dart:io';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
// import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hatchery_im/flavors/Flavors.dart';

class VideoPlayPage extends StatefulWidget {
  final String videoUrl;
  VideoPlayPage(this.videoUrl);
  @override
  VideoPlayState createState() => VideoPlayState();
}

class VideoPlayState extends State<VideoPlayPage> {
  late final VlcPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VlcPlayerController.network(
      'https://assets.blz-contentstack.com/v3/assets/blt9c12f249ac15c7ec/blta86655adc07874e8/625ed518c6d11125f3c9b13d/WOW-2020-15717_zhCN_HORZ_PK_LearnMore_compressed.mp4  ',
      hwAcc: HwAcc.auto,
      autoPlay: false,
      options: VlcPlayerOptions(),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    await _videoPlayerController.stopRendererScanning();
    await _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: VlcPlayer(
            controller: _videoPlayerController,
            aspectRatio: 16 / 9,
            placeholder: Center(child: CircularProgressIndicator()),
          ),
        ));
  }
}
