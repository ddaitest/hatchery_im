import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/utils.dart';

import '../../../config.dart';
import '../../AppContext.dart';
import '../../log.dart';
import '../../tools.dart';

class VoiceMessageWidget extends StatelessWidget {
  final Map<String, dynamic> voiceMessageMap;
  final MessageBelongType messageBelongType;
  VoiceMessageWidget(this.voiceMessageMap, this.messageBelongType);

  late final AudioPlayer audioPlayer =
      AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  late final int? _duration;
  late final String? _voiceUrl;

  init() {
    _voiceUrl = voiceMessageMap["voice_url"] ?? null;
    _duration = voiceMessageMap["time"] ?? 0;
    Log.red("_initAudioPlayer $_voiceUrl ${_duration}");
    if (_voiceUrl != null) {
      _initAudioPlayer();
    } else {
      showToast("语音加载失败");
    }
  }

  void _initAudioPlayer() {
    audioPlayer.setUrl(_voiceUrl!);
  }

  Future<int> play() async {
    int result = await audioPlayer.play(_voiceUrl!);
    return result;
  }

  // Future<int> _stop() async {
  //   final result = await audioPlayer.stop();
  //   if (result == 1) {
  //     _playerState = PlayerState.STOPPED;
  //   }
  //   return result;
  // }

  Future<int> pause() async {
    int result = await audioPlayer.pause();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    init();
    return _voiceMessageView(messageBelongType);
  }

  Widget _voiceMessageView(MessageBelongType belongType) {
    if (_voiceUrl!.contains("http") && _voiceUrl != null) {
      return GestureDetector(
        onTap: () => audioPlayer.state == PlayerState.PAUSED ||
                audioPlayer.state == PlayerState.STOPPED
            ? play()
            : pause(),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: belongType == MessageBelongType.Receiver
                ? Colors.white
                : Flavors.colorInfo.mainColor,
          ),
          padding: const EdgeInsets.all(10),
          child: Container(
            alignment: belongType == MessageBelongType.Receiver
                ? Alignment.centerRight
                : Alignment.centerLeft,
            height: 25.0.h,
            width: _setMessageWidth(_duration!),
            child: Text("${videoTimeFormat(_duration!)}",
                style: belongType == MessageBelongType.Receiver
                    ? Flavors.textStyles.chatBubbleVoiceReceiverText
                    : Flavors.textStyles.chatBubbleVoiceSenderText),
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Flavors.colorInfo.mainColor,
        ),
        padding: const EdgeInsets.all(10),
        child: Container(
          alignment: Alignment.centerLeft,
          height: 25.0.h,
          width: 100.0.w,
          child: Text('发送中....',
              style: Flavors.textStyles.chatBubbleVoiceSenderText),
        ),
      );
    }
  }

  double _setMessageWidth(int seconds) {
    if (seconds <= 20) {
      return (seconds * 10).w;
    } else {
      return 200.0.w;
    }
  }
}
