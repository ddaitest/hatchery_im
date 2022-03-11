import 'dart:async';
import 'dart:math';
import 'package:hatchery_im/business/chat_detail/chat_detail_page.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../../config.dart';
import '../../log.dart';
import '../../tools.dart';

class VoiceMessageWidget extends StatefulWidget {
  final Map<String, dynamic> voiceMessageMap;
  final MessageBelongType messageBelongType;
  VoiceMessageWidget(this.voiceMessageMap, this.messageBelongType);
  @override
  _VoiceMessageWidgetState createState() => _VoiceMessageWidgetState();
}

class _VoiceMessageWidgetState extends State<VoiceMessageWidget> {
  AudioPlayer _audioPlayer = AudioPlayer();
  int? _totalTime;

  @override
  void initState() {
    _audioPlayer.setUrl(widget.voiceMessageMap["voice_url"]);
    Log.green("voice_url ${widget.voiceMessageMap["voice_url"]}");
    _totalTime = widget.voiceMessageMap["time"] ?? 0;
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _totalTime = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _voiceMessageView();
  }

  Widget _voiceMessageView() {
    return GestureDetector(
        onTap: () => _audioPlayer.playerState.playing ? _stop() : _play(),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.messageBelongType == MessageBelongType.Receiver
                ? Colors.white
                : Flavors.colorInfo.mainColor,
          ),
          padding: widget.messageBelongType == MessageBelongType.Receiver
              ? const EdgeInsets.only(
                  left: 12.0, right: 15.0, top: 10.0, bottom: 12.0)
              : const EdgeInsets.only(
                  left: 15.0, right: 12.0, top: 10.0, bottom: 12.0),
          child: Container(
            height: 20.0.h,
            width: _setMessageWidth(_totalTime!),
            child: widget.messageBelongType == MessageBelongType.Receiver
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamBuilder<PlayerState?>(
                          stream: _audioPlayer.playerStateStream,
                          builder: (context, value) {
                            return Icon(
                                value.data!.playing
                                    ? Icons.stop_circle_outlined
                                    : Icons.play_circle_outlined,
                                size: 25.0,
                                color: Flavors.colorInfo.diver);
                          }),
                      StreamBuilder<Duration?>(
                          stream: _audioPlayer.positionStream,
                          builder: (context, positionDuration) {
                            if (positionDuration.data!.inSeconds <
                                _totalTime!) {
                              return Text(
                                  '${(_totalTime! - positionDuration.data!.inSeconds).toString()}"',
                                  style: Flavors
                                      .textStyles.chatBubbleReceiverText);
                            } else {
                              _stop();
                              return Text('${_totalTime.toString()}"',
                                  style: Flavors
                                      .textStyles.chatBubbleReceiverText);
                            }
                          })
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamBuilder<Duration?>(
                          stream: _audioPlayer.positionStream,
                          builder: (context, positionDuration) {
                            if (positionDuration.data!.inSeconds <
                                _totalTime!) {
                              return Text(
                                  '${(_totalTime! - positionDuration.data!.inSeconds).toString()}"',
                                  style:
                                      Flavors.textStyles.chatBubbleSenderText);
                            } else {
                              _stop();
                              return Text('${_totalTime.toString()}"',
                                  style:
                                      Flavors.textStyles.chatBubbleSenderText);
                            }
                          }),
                      StreamBuilder<PlayerState?>(
                          stream: _audioPlayer.playerStateStream,
                          builder: (context, value) {
                            return Icon(
                                value.data!.playing
                                    ? Icons.stop_circle_outlined
                                    : Icons.play_circle_outlined,
                                size: 25.0,
                                color: Flavors.colorInfo.mainBackGroundColor);
                          }),
                    ],
                  ),
          ),
        ));
  }

  _play() async {
    await _audioPlayer.play();
  }

  _stop() async {
    await _audioPlayer.stop();
    await _audioPlayer.seek(Duration.zero);
  }

  double _setMessageWidth(int seconds) {
    if (seconds <= 5) {
      return (Flavors.sizesInfo.screenWidth / 7).w;
    } else if (seconds > 5 && seconds <= 15) {
      return (Flavors.sizesInfo.screenWidth / 4).w;
    } else if (seconds > 15 && seconds <= 45) {
      return (Flavors.sizesInfo.screenWidth / 3).w;
    } else {
      return (Flavors.sizesInfo.screenWidth / 2).w;
    }
  }
}
