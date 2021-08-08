import 'dart:async';
import 'package:hatchery_im/busniess/chat_detail/chat_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/common/widget/chat_detail/voiceMessageView.dart';
import 'package:hatchery_im/common/widget/chat_detail/imageMessageView.dart';
import 'package:hatchery_im/common/widget/chat_detail/videoMessageView.dart';

class ChatBubble extends StatefulWidget {
  final String avatarPicUrl;
  final MessageBelongType messageBelongType;
  final Message friendsHistoryMessages;

  ChatBubble(
      {required this.avatarPicUrl,
      required this.messageBelongType,
      required this.friendsHistoryMessages});

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: _chatBubbleView('${widget.avatarPicUrl}'));
  }

  Widget _chatBubbleView(String? avatarUrl) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      textDirection: widget.messageBelongType == MessageBelongType.Receiver
          ? TextDirection.ltr
          : TextDirection.rtl,
      children: [
        CachedNetworkImage(
            imageUrl: avatarUrl!,
            placeholder: (context, url) => CircleAvatar(
                  backgroundImage: AssetImage('images/default_avatar.png'),
                  maxRadius: 20,
                ),
            errorWidget: (context, url, error) => CircleAvatar(
                  backgroundImage: AssetImage('images/default_avatar.png'),
                  maxRadius: 20,
                ),
            imageBuilder: (context, imageProvider) {
              return CircleAvatar(
                backgroundImage: imageProvider,
                maxRadius: 20,
              );
            }),
        SizedBox(width: 10.0.w),
        Column(
          crossAxisAlignment: _createTimePosition(widget.messageBelongType),
          children: [
            switchMessageTypeView(widget.friendsHistoryMessages.contentType,
                widget.messageBelongType),
            SizedBox(height: 5.0.h),
            Text(
                '${checkMessageTime(widget.friendsHistoryMessages.createTime)}',
                maxLines: 10,
                softWrap: true,
                style: Flavors.textStyles.chatBubbleTimeText),
          ],
        ),
      ],
    );
  }

  Widget switchMessageTypeView(
      String messageType, MessageBelongType belongType) {
    Widget finalView;
    switch (messageType) {
      case "TEXT":
        {
          // finalView = ImageMessageWidget(imageTestUrl, belongType);
          finalView = _textMessageView(belongType);
          // finalView = VoiceMessageWidget(exampleAudioFilePath, belongType);
          // finalView = VideoMessageWidget(videoTestUrl, belongType);
        }
        break;
      case "IMAGE":
        {
          var temp = widget.friendsHistoryMessages.content;
          //TODO
          finalView = ImageMessageWidget(temp["TODO"], belongType);
        }
        break;
      case "VIDEO":
        {
          //TODO
          var temp = widget.friendsHistoryMessages.content;
          finalView = ImageMessageWidget(temp["TODO"], belongType);
        }
        break;
      case "VOICE":
        {
          //TODO
          var temp = widget.friendsHistoryMessages.content;
          finalView = ImageMessageWidget(temp["TODO"], belongType);
        }
        break;
      case "FILE":
        {
          finalView = _textMessageView(belongType);
        }
        break;
      case "URL":
        {
          finalView = _textMessageView(belongType);
        }
        break;
      case "CARD":
        {
          finalView = _textMessageView(belongType);
        }
        break;
      case "STICKER":
        {
          finalView = _textMessageView(belongType);
        }
        break;
      default:
        {
          finalView = _textMessageView(belongType);
        }
        break;
    }
    return finalView;
  }

  Widget _textMessageView(MessageBelongType belongType) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: Flavors.sizesInfo.screenWidth - 100.0.w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: belongType == MessageBelongType.Receiver
            ? Colors.white
            : Flavors.colorInfo.mainColor,
      ),
      padding: const EdgeInsets.all(10),
      child: Text('${widget.friendsHistoryMessages.content}',
          maxLines: 10,
          softWrap: true,
          style: widget.messageBelongType == MessageBelongType.Receiver
              ? Flavors.textStyles.chatBubbleReceiverText
              : Flavors.textStyles.chatBubbleSenderText),
    );
  }

  CrossAxisAlignment _createTimePosition(MessageBelongType belongType) {
    if (belongType == MessageBelongType.Receiver) {
      return CrossAxisAlignment.end;
    } else {
      return CrossAxisAlignment.start;
    }
  }
}
