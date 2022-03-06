import 'dart:async';
import 'package:hatchery_im/business/chat_detail/chat_detail_page.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../../config.dart';
import '../../../manager/chat_manager/voiceBubbleManager.dart';
import '../../AppContext.dart';

class VoiceMessageWidget extends StatefulWidget {
  final Map<String, dynamic> voiceMessageMap;
  final MessageBelongType messageBelongType;
  VoiceMessageWidget(this.voiceMessageMap, this.messageBelongType);
  @override
  _VoiceMessageWidgetState createState() => _VoiceMessageWidgetState();
}

class _VoiceMessageWidgetState extends State<VoiceMessageWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final manager = App.manager<VoiceBubbleManager>();

  @override
  void initState() {
    manager.init(widget.voiceMessageMap);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _voiceMessageView(widget.messageBelongType);
  }

  Widget _voiceMessageView(MessageBelongType belongType) {
    return GestureDetector(
      onTap: () => manager.play(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: belongType == MessageBelongType.Receiver
              ? Colors.white
              : Flavors.colorInfo.mainColor,
        ),
        padding: const EdgeInsets.all(10),
        child: Container(
          height: 25.0.h,
          width: _setMessageWidth(widget.voiceMessageMap["time"]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('....',
                  style: belongType == MessageBelongType.Receiver
                      ? Flavors.textStyles.chatBubbleVoiceReceiverText
                      : Flavors.textStyles.chatBubbleVoiceSenderText),
              Icon(
                  manager.audioPlayer.playing
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

  double _setMessageWidth(int seconds) {
    if (seconds <= 20) {
      return (seconds * 10).w;
    } else {
      return 200.0.w;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
