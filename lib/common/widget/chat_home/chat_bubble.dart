import 'dart:convert';

import 'package:hatchery_im/api/engine/entity.dart';
import 'dart:convert' as convert;
import 'package:hatchery_im/business/chat_detail/chat_detail_page.dart';
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
import 'package:hatchery_im/common/widget/chat_detail/cardMessageView.dart';
import 'package:hatchery_im/common/widget/chat_detail/fileMessageView.dart';
import 'package:hatchery_im/common/widget/chat_detail/locationMessageView.dart';
import 'package:hatchery_im/routers.dart';

import '../../../config.dart';

class ChatBubble extends StatefulWidget {
  final String userID;
  final String avatarPicUrl;
  final MessageBelongType messageBelongType;
  final Message friendsHistoryMessages;

  ChatBubble(
      {required this.userID,
      required this.avatarPicUrl,
      required this.messageBelongType,
      required this.friendsHistoryMessages});

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: _chatBubbleView('${widget.avatarPicUrl}'));
  }

  Widget _chatBubbleView(String? avatarUrl) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
              '${checkMessageTime(widget.friendsHistoryMessages.createTime)}',
              maxLines: 1,
              softWrap: true,
              style: Flavors.textStyles.chatBubbleTimeText),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          textDirection: widget.messageBelongType == MessageBelongType.Receiver
              ? TextDirection.ltr
              : TextDirection.rtl,
          children: [
            GestureDetector(
              onTap: () => widget.messageBelongType ==
                      MessageBelongType.Receiver
                  ? Routers.navigateTo('/friend_profile', arg: widget.userID)
                  : null,
              child: Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: CachedNetworkImage(
                      imageUrl: avatarUrl!,
                      placeholder: (context, url) => CircleAvatar(
                            backgroundImage:
                                AssetImage('images/default_avatar.png'),
                            maxRadius: 20,
                          ),
                      errorWidget: (context, url, error) => CircleAvatar(
                            backgroundImage:
                                AssetImage('images/default_avatar.png'),
                            maxRadius: 20,
                          ),
                      imageBuilder: (context, imageProvider) {
                        return CircleAvatar(
                          backgroundImage: imageProvider,
                          maxRadius: 20,
                        );
                      })),
            ),
            SizedBox(width: 15.0.w),
            switchMessageTypeView(widget.friendsHistoryMessages.contentType,
                widget.messageBelongType),
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
          Map<String, dynamic> temp =
              convert.jsonDecode(widget.friendsHistoryMessages.content);
          finalView = _textMessageView(temp, belongType);
          // Map<String, dynamic> temp = {
          //   "name": "北京市门头沟体育馆",
          //   "icon": "",
          //   "latitude": "39.941325",
          //   "longitude": "116.101292"
          // };
          // finalView =
          //     LocationMessageWidget(belongType, temp, MapOriginType.Share);
          // finalView = VoiceMessageWidget(exampleAudioFilePath, belongType);
          // finalView = VideoMessageWidget(videoTestUrl, belongType);
        }
        break;
      case "IMAGE":
        {
          Map<String, dynamic> temp =
              convert.jsonDecode(widget.friendsHistoryMessages.content);
          print("DEBUG=> widget. ${widget.friendsHistoryMessages.content}");

          //TODO
          finalView = ImageMessageWidget(temp["img_url"], belongType);
        }
        break;
      case "VIDEO":
        {
          //TODO
          // Map<String, dynamic> temp =
          //     convert.jsonDecode(widget.friendsHistoryMessages.content);
          finalView = VideoMessageWidget(
              widget.friendsHistoryMessages.content, belongType);
        }
        break;
      case "VOICE":
        {
          //TODO
          // print(
          //     "DEBUG=> widget.friendsHistoryMessages.content ${widget.friendsHistoryMessages.content}");
          // Map<String, dynamic> temp =
          //     convert.jsonDecode(widget.friendsHistoryMessages.content);
          finalView = VoiceMessageWidget(
              widget.friendsHistoryMessages.content, belongType);
        }
        break;
      case "FILE":
        {
          Map<String, dynamic> temp =
              convert.jsonDecode(widget.friendsHistoryMessages.content);
          finalView = FileMessageWidget(belongType, temp);
        }
        break;
      case "URL":
        {
          Map<String, dynamic> temp =
              convert.jsonDecode(widget.friendsHistoryMessages.content);
          finalView = _textMessageView(temp, belongType);
        }
        break;
      case "CARD":
        {
          Map<String, dynamic> temp =
              convert.jsonDecode(widget.friendsHistoryMessages.content);
          finalView = CardMessageWidget(belongType, temp);
        }
        break;
      case "GEO":
        {
          Map<String, dynamic> temp =
              convert.jsonDecode(widget.friendsHistoryMessages.content);
          finalView =
              LocationMessageWidget(belongType, temp, MapOriginType.Share);
        }
        break;
      default:
        {
          Map<String, dynamic> temp =
              convert.jsonDecode(widget.friendsHistoryMessages.content);
          finalView = _textMessageView(temp, belongType);
        }
        break;
    }
    return finalView;
  }

  Widget _textMessageView(
      Map<String, dynamic> content, MessageBelongType belongType) {
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
      child: Text('${content['text']}',
          maxLines: 10,
          softWrap: true,
          style: widget.messageBelongType == MessageBelongType.Receiver
              ? Flavors.textStyles.chatBubbleReceiverText
              : Flavors.textStyles.chatBubbleSenderText),
    );
  }

  // CrossAxisAlignment _createTimePosition(MessageBelongType belongType) {
  //   if (belongType == MessageBelongType.Receiver) {
  //     return CrossAxisAlignment.end;
  //   } else {
  //     return CrossAxisAlignment.start;
  //   }
  // }
}
