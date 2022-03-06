import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/store/LocalStore.dart';
import 'package:just_audio/just_audio.dart';
import '../../common/utils.dart';

class VoiceBubbleManager extends ChangeNotifier {
  final _audioPlayer = AudioPlayer();
  Duration? _audioDuration;
  int? _duration;
  String? _voiceUrl;
  int? _totalDuration;
  String? _timeLeftText;
  AudioPlayer get audioPlayer => _audioPlayer;
  Duration? get audioDuration => _audioDuration;
  int? get duration => _duration;
  String? get voiceUrl => _voiceUrl;
  int? get totalDuration => _totalDuration;
  String? get timeLeftText => _timeLeftText;

  /// 初始化
  init(Map<String, dynamic> voiceMessageMap) {
    _initAudioPlayer(voiceMessageMap);
  }

  void _initAudioPlayer(Map<String, dynamic> voiceMessageMap) async {
    await _audioPlayer.setUrl(voiceMessageMap["voice_url"]);
    // _totalDuration = voiceMessageMap["time"];
  }

  // void _voiceCountDownTime() {
  //   if (_audioPosition != null && _audioDuration != null) {
  //     int? _finalTimeSeconds =
  //         _audioDuration!.inSeconds - _audioPosition!.inSeconds;
  //     if (_finalTimeSeconds > 0) {
  //       _timeLeftText = durationTransform(_finalTimeSeconds);
  //     } else if (_finalTimeSeconds == 0) {
  //       voiceFinishReset();
  //     } else {
  //       voiceFinishReset();
  //     }
  //   }
  // }

  // void voiceFinishReset() {
  //   _timeLeftText = durationTransform(_audioDuration!.inSeconds);
  //   stop();
  // }
  //
  play() async {
    await _audioPlayer.play();
  }

  pause() async {
    await _audioPlayer.pause();
  }

  stop() async {
    await _audioPlayer.stop();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
