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
      onTap: () => manager.isPlaying ? manager.pause() : manager.play(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: belongType == MessageBelongType.Receiver
              ? Colors.white
              : Flavors.colorInfo.mainColor,
        ),
        padding: const EdgeInsets.only(
            left: 10.0, right: 20.0, top: 10.0, bottom: 10.0),
        child: Container(
          height: 20.0.h,
          width: _setMessageWidth(widget.voiceMessageMap["time"]),
          child: belongType == MessageBelongType.Receiver
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Selector<VoiceBubbleManager, String?>(
                        builder: (BuildContext context, String? value,
                            Widget? child) {
                          return Text('${manager.durationTime ?? '...'}',
                              style: Flavors
                                  .textStyles.chatBubbleVoiceReceiverText);
                        },
                        selector: (BuildContext context,
                            VoiceBubbleManager voiceBubbleManager) {
                          return voiceBubbleManager.durationTime;
                        },
                        shouldRebuild: (pre, next) => (pre != next)),
                    Selector<VoiceBubbleManager, bool>(
                        builder:
                            (BuildContext context, bool value, Widget? child) {
                          return Icon(
                              value
                                  ? Icons.pause_circle_outline_outlined
                                  : Icons.play_circle_outline,
                              size: 25.0,
                              color: Flavors.colorInfo.diver);
                        },
                        selector: (BuildContext context,
                            VoiceBubbleManager voiceBubbleManager) {
                          return voiceBubbleManager.isPlaying;
                        },
                        shouldRebuild: (pre, next) => (pre != next)),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Selector<VoiceBubbleManager, bool>(
                        builder:
                            (BuildContext context, bool value, Widget? child) {
                          return Icon(
                              value
                                  ? Icons.pause_circle_outline_outlined
                                  : Icons.play_circle_outline,
                              size: 25.0,
                              color: Flavors.colorInfo.mainBackGroundColor);
                        },
                        selector: (BuildContext context,
                            VoiceBubbleManager voiceBubbleManager) {
                          return voiceBubbleManager.isPlaying;
                        },
                        shouldRebuild: (pre, next) => (pre != next)),
                    Selector<VoiceBubbleManager, String?>(
                        builder: (BuildContext context, String? value,
                            Widget? child) {
                          return Text('${manager.durationTime ?? '...'}',
                              style:
                                  Flavors.textStyles.chatBubbleVoiceSenderText);
                        },
                        selector: (BuildContext context,
                            VoiceBubbleManager voiceBubbleManager) {
                          return voiceBubbleManager.durationTime;
                        },
                        shouldRebuild: (pre, next) => (pre != next)),
                  ],
                ),
        ),
      ),
    );
  }

  double _setMessageWidth(int seconds) {
    if (seconds <= 20) {
      return Flavors.sizesInfo.screenWidth - 300.0.w;
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
