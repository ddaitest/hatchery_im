import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/store/LocalStore.dart';
import 'package:just_audio/just_audio.dart';
import '../../common/log.dart';
import '../../common/tools.dart';
import '../../common/utils.dart';

class VoiceBubbleManager extends ChangeNotifier {
  AudioPlayer? _audioPlayer;
  int _totalTime = 0;
  int? _durationTime;
  AudioPlayer? get audioPlayer => _audioPlayer;
  int? get durationTime => _durationTime;

  /// 初始化
  init(Map<String, dynamic> voiceMessageMap) {
    _audioPlayer = AudioPlayer();
    _initAudioPlayer(voiceMessageMap);
  }

  void _initAudioPlayer(Map<String, dynamic> voiceMessageMap) async {
    _totalTime = voiceMessageMap["time"];
    _durationTime = _totalTime;
    notifyListeners();
    await _audioPlayer?.setUrl(voiceMessageMap["voice_url"]).then((value) {
      if (value != null) {
        _totalTime = value.inSeconds;
        _durationTime = _totalTime;
        notifyListeners();
      }
    });
    _audioPositionListen();
  }

  void _audioPositionListen() {
    _audioPlayer?.positionStream.listen((event) {
      _durationTime = _totalTime - event.inSeconds;
      Log.green("_durationTime $_durationTime");
      if (event.inSeconds >= _totalTime) {
        _durationTime = _totalTime;
        stop();
      }
      notifyListeners();
    });
  }

  play() async {
    await _audioPlayer?.play();
    Log.green("play");
  }

  pause() async {
    await _audioPlayer?.pause();
  }

  stop() async {
    await _audioPlayer?.stop();
    _audioPlayer?.seek(Duration.zero);
    Log.green("stop");
  }

  void disposeM() {
    _durationTime = null;
    _totalTime = 0;
    _audioPlayer?.dispose();
  }
}
