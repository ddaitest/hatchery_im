import 'dart:async';
import 'package:hatchery_im/busniess/chat_detail/chat_detail_page.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VoiceMessageWidget extends StatefulWidget {
  final String voiceMessageUrl;
  final MessageBelongType messageBelongType;
  VoiceMessageWidget(this.voiceMessageUrl, this.messageBelongType);
  @override
  _VoiceMessageWidgetState createState() => _VoiceMessageWidgetState();
}

class _VoiceMessageWidgetState extends State<VoiceMessageWidget> {
  late AudioPlayer _audioPlayer;
  Timer? _countDownTimer;
  PlayerState? _audioPlayerState;
  Duration? _audioDuration;
  String get _durationText => _audioDuration?.toString().split('.').first ?? '';
  @override
  void initState() {
    _initAudioPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _voiceMessageView(widget.messageBelongType);
  }

  void _initAudioPlayer() {
    AudioPlayer _audioPlayer;
    _audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
    _audioPlayer.onDurationChanged.listen((duration) {
      _countDownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        int _currentTime = duration.inSeconds;
        if (timer.tick == duration.inSeconds) {
          _countDownTimer!.cancel();
          _countDownTimer = null;
        } else {
          setState(() => _currentTime--);
        }
      });
    });
  }

  Widget _voiceMessageView(MessageBelongType belongType) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: belongType == MessageBelongType.Receiver
            ? Colors.white
            : Flavors.colorInfo.mainColor,
      ),
      padding: EdgeInsets.all(10),
      child: Container(
        height: 20.0.h,
        width: 200.0.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('01:35',
                style: belongType == MessageBelongType.Receiver
                    ? Flavors.textStyles.chatBubbleVoiceReceiverText
                    : Flavors.textStyles.chatBubbleVoiceSenderText),
            Container(
              width: 100.0.w,
              child: LinearProgressIndicator(
                backgroundColor: Flavors.colorInfo.lightGrep,
                valueColor: AlwaysStoppedAnimation(
                    belongType == MessageBelongType.Receiver
                        ? Flavors.colorInfo.blueGrey
                        : Flavors.colorInfo.mainTextColor),
                value: 0.5,
              ),
            ),
            Icon(Icons.play_circle_outline,
                size: 25.0,
                color: belongType == MessageBelongType.Receiver
                    ? Flavors.colorInfo.blueGrey
                    : Flavors.colorInfo.mainBackGroundColor)
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _countDownTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
