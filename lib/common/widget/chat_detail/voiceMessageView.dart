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
import '../../../manager/chat_manager/voiceBubbleManager.dart';
import '../../AppContext.dart';
import '../../tools.dart';

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
        onTap: () => manager.audioPlayer!.playerState.playing
            ? manager.stop()
            : manager.play(),
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
            width: _setMessageWidth(widget.voiceMessageMap["time"]),
            child: belongType == MessageBelongType.Receiver
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamBuilder<PlayerState?>(
                          stream: manager.audioPlayer?.playerStateStream,
                          builder: (context, value) {
                            return Icon(
                                value.data!.playing
                                    ? Icons.stop_circle_outlined
                                    : Icons.play_circle_outlined,
                                size: 25.0,
                                color: Flavors.colorInfo.diver);
                          }),
                      Selector<VoiceBubbleManager, int?>(
                          builder: (BuildContext context, int? value,
                              Widget? child) {
                            return Text('${value.toString()}"',
                                style:
                                    Flavors.textStyles.chatBubbleReceiverText);
                          },
                          selector: (BuildContext context,
                              VoiceBubbleManager voiceBubbleManager) {
                            return voiceBubbleManager.durationTime;
                          },
                          shouldRebuild: (pre, next) => (pre != next)),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Selector<VoiceBubbleManager, int?>(
                          builder: (BuildContext context, int? value,
                              Widget? child) {
                            return Text('${value.toString()}"',
                                style: Flavors.textStyles.chatBubbleSenderText);
                          },
                          selector: (BuildContext context,
                              VoiceBubbleManager voiceBubbleManager) {
                            return voiceBubbleManager.durationTime;
                          },
                          shouldRebuild: (pre, next) => (pre != next)),
                      StreamBuilder<PlayerState?>(
                          stream: manager.audioPlayer?.playerStateStream,
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

  @override
  void dispose() {
    super.dispose();
    manager.disposeM();
  }
}
