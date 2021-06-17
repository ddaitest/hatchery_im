import 'dart:async';
import 'package:hatchery_im/busniess/chat_detail/chat_detail_page.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/utils.dart';

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
  PlayerState _playerState = PlayerState.STOPPED;
  Duration? _audioDuration;
  Duration? _audioPosition;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  String? _durationText;
  bool get _isPlaying => _playerState == PlayerState.PLAYING;
  bool get _isPaused => _playerState == PlayerState.PAUSED;
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
    _audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
    _audioPlayer.setUrl(widget.voiceMessageUrl);
    _audioPlayer.onDurationChanged.listen((duration) {
      if (_durationText == null) _audioDuration = duration;
      setState(() {
        _durationText = durationTransform(duration.inSeconds);
      });
    });
    _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
          _audioPosition = p;
          if (_audioPosition != null && _audioDuration != null)
            _voiceCountDownTime();
        }));

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _audioPlayerState = state;
        });
      }
    });
  }

  Future<int> _play() async {
    final playPosition = (_audioPosition != null &&
            _audioDuration != null &&
            _audioPosition!.inMilliseconds > 0 &&
            _audioPosition!.inMilliseconds < _audioDuration!.inMilliseconds)
        ? _audioPosition
        : null;
    final result = await _audioPlayer.play(widget.voiceMessageUrl,
        isLocal: false, position: playPosition);
    if (result == 1) {
      setState(() => _playerState = PlayerState.PLAYING);
    }

    // default playback rate is 1.0
    // this should be called after _audioPlayer.play() or _audioPlayer.resume()
    // this can also be called everytime the user wants to change playback rate in the UI
    _audioPlayer.setPlaybackRate();

    return result;
  }

  Future<int> _stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.STOPPED;
        _audioPosition = const Duration();
      });
    }
    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) {
      setState(() => _playerState = PlayerState.PAUSED);
    }
    return result;
  }

  Widget _voiceMessageView(MessageBelongType belongType) {
    return GestureDetector(
      onTap: () => _isPlaying ? _pause() : _play(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: belongType == MessageBelongType.Receiver
              ? Colors.white
              : Flavors.colorInfo.mainColor,
        ),
        padding: EdgeInsets.all(10),
        child: Container(
          height: 30.0.h,
          width: 200.0.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_durationText ?? '...',
                  style: belongType == MessageBelongType.Receiver
                      ? Flavors.textStyles.chatBubbleVoiceReceiverText
                      : Flavors.textStyles.chatBubbleVoiceSenderText),
              Container(
                width: 120.0.w,
                child: LinearProgressIndicator(
                  backgroundColor: Flavors.colorInfo.lightGrep,
                  valueColor: AlwaysStoppedAnimation(
                      belongType == MessageBelongType.Receiver
                          ? Flavors.colorInfo.blueGrey
                          : Flavors.colorInfo.mainTextColor),
                  value: (_audioPosition != null &&
                          _audioDuration != null &&
                          _audioPosition!.inMilliseconds > 0 &&
                          _audioPosition!.inMilliseconds <
                              _audioDuration!.inMilliseconds)
                      ? _audioPosition!.inMilliseconds /
                          _audioDuration!.inMilliseconds
                      : 0.02,
                ),
              ),
              Icon(
                  _playerState == PlayerState.PLAYING
                      ? Icons.pause_circle_outline
                      : Icons.play_circle_outline,
                  size: 30.0,
                  color: belongType == MessageBelongType.Receiver
                      ? Flavors.colorInfo.blueGrey
                      : Flavors.colorInfo.mainBackGroundColor)
            ],
          ),
        ),
      ),
    );
  }

  void _voiceCountDownTime() {
    if (_audioPosition != null && _audioDuration != null) {
      int? _finalTimeSeconds =
          _audioDuration!.inSeconds - _audioPosition!.inSeconds;
      if (_finalTimeSeconds > 0) {
        _durationText = durationTransform(_finalTimeSeconds);
      } else if (_finalTimeSeconds == 0) {
        voiceFinishReset();
      } else {
        voiceFinishReset();
      }
    }
  }

  void voiceFinishReset() {
    _durationText = durationTransform(_audioDuration!.inSeconds);
    _stop();
  }

  @override
  void dispose() {
    // _countDownTimer?.cancel();
    _audioPlayer.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    super.dispose();
  }
}
