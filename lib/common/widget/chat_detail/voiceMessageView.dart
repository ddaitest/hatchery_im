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

class VoiceMessageWidget extends StatelessWidget {
  final Map<String, dynamic> voiceMessageMap;
  final MessageBelongType messageBelongType;
  VoiceMessageWidget(this.voiceMessageMap, this.messageBelongType);

  @override
  Widget build(BuildContext context) {
    return _voiceMessageView(messageBelongType);
  }

  Widget _voiceMessageView(MessageBelongType belongType) {
    AudioPlayer _audioPlayer = AudioPlayer();
    int _totalTime = voiceMessageMap["time"] ?? 0;
    _audioPlayer.setUrl(voiceMessageMap["voice_url"]).whenComplete(() {
      _audioPlayer.load().then((value) => _totalTime = value!.inSeconds);
    });
    return GestureDetector(
        onTap: () => _audioPlayer.playerState.playing
            ? _audioPlayer.stop()
            : _audioPlayer.play(),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: belongType == MessageBelongType.Receiver
                ? Colors.white
                : Flavors.colorInfo.mainColor,
          ),
          padding: belongType == MessageBelongType.Receiver
              ? const EdgeInsets.only(
                  left: 12.0, right: 15.0, top: 10.0, bottom: 12.0)
              : const EdgeInsets.only(
                  left: 15.0, right: 12.0, top: 10.0, bottom: 12.0),
          child: Container(
            height: 20.0.h,
            width: _setMessageWidth(voiceMessageMap["time"]),
            child: belongType == MessageBelongType.Receiver
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
                            if (positionDuration.data!.inSeconds < _totalTime) {
                              return Text(
                                  '${(_totalTime - positionDuration.data!.inSeconds).toString()}"',
                                  style: Flavors
                                      .textStyles.chatBubbleReceiverText);
                            } else {
                              _audioPlayer.stop();
                              _audioPlayer.seek(Duration.zero);
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
                            if (positionDuration.data!.inSeconds < _totalTime) {
                              return Text(
                                  '${(_totalTime - positionDuration.data!.inSeconds).toString()}"',
                                  style:
                                      Flavors.textStyles.chatBubbleSenderText);
                            } else {
                              _audioPlayer.stop();
                              _audioPlayer.seek(Duration.zero);
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

  double _setMessageWidth(int seconds) {
    if (seconds <= 30) {
      return Flavors.sizesInfo.screenWidth - (280.0 - seconds).w;
    } else {
      return Flavors.sizesInfo.screenWidth - 200.0.w;
    }
  }
}
