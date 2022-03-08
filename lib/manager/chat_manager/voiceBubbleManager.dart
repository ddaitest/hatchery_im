import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/store/LocalStore.dart';
import 'package:just_audio/just_audio.dart';
import '../../common/log.dart';
import '../../common/tools.dart';
import '../../common/utils.dart';

class VoiceBubbleManager extends ChangeNotifier {
  final _audioPlayer = AudioPlayer();
  String? _durationTime;
  bool _isPlaying = false;
  AudioPlayer get audioPlayer => _audioPlayer;
  String? get durationTime => _durationTime;
  bool get isPlaying => _isPlaying;

  /// 初始化
  init(Map<String, dynamic> voiceMessageMap) {
    _initAudioPlayer(voiceMessageMap);
  }

  void _initAudioPlayer(Map<String, dynamic> voiceMessageMap) async {
    await _audioPlayer.setUrl(voiceMessageMap["voice_url"]);
    _durationTime = mediaTimeFormat(voiceMessageMap["time"]);
    notifyListeners();
    _audioPositionListen();
  }

  void _audioPositionListen() {
    _audioPlayer.durationStream.listen((event) {
      Log.green("positionStream positionStream");
      _durationTime = mediaTimeFormat(event!.inSeconds);
      Log.green("_durationTime $_durationTime");
      // if (event.inSeconds <= 0) {
      //   stop();
      // }
      // notifyListeners();
    });
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

  play() async {
    await _audioPlayer.play();
    _isPlaying = true;
    notifyListeners();
  }

  pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  stop() async {
    await _audioPlayer.stop();
    _isPlaying = false;
  }

  void disposeM() {
    _isPlaying = false;
    _durationTime = "";
    _audioPlayer.dispose();
  }
}
