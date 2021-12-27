import 'dart:convert' as convert;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/AppContext.dart';
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
import 'package:hatchery_im/manager/chat_manager/chatDetailManager.dart';
import 'package:hatchery_im/routers.dart';
import 'package:provider/provider.dart';

import '../../../config.dart';
import '../aboutAvatar.dart';

class ChatBubble extends StatelessWidget {
  final String userID;
  final MessageBelongType messageBelongType;
  final Message contentMessages;

  ChatBubble(
      {required this.userID,
      required this.messageBelongType,
      required this.contentMessages});

  final manager = App.manager<ChatDetailManager>();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: _chatBubbleView('${_getAvatarPicUrl()}'));
  }

  String _getAvatarPicUrl() {
    if (contentMessages.sender == manager.myProfileData!.userID) {
      return manager.myProfileData!.icon!;
    } else {
      return contentMessages.icon;
    }
  }

  Widget _chatBubbleView(String? avatarUrl) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
              "${checkMessageTime(contentMessages.createTime).toString().contains("-") ? checkMessageTime(contentMessages.createTime).toString().split(" ")[0] : checkMessageTime(contentMessages.createTime)}",
              maxLines: 1,
              softWrap: true,
              style: Flavors.textStyles.chatBubbleTimeText),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          textDirection: messageBelongType == MessageBelongType.Receiver
              ? TextDirection.ltr
              : TextDirection.rtl,
          children: [
            GestureDetector(
              onTap: () => messageBelongType == MessageBelongType.Receiver
                  ? Routers.navigateTo('/friend_profile',
                      arg: contentMessages.sender)
                  : null,
              child: netWorkAvatar(avatarUrl, 20.0),
            ),
            SizedBox(width: 15.0.w),
            contentMessages.type == "GROUP" &&
                    messageBelongType == MessageBelongType.Receiver
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contentMessages.nick,
                        style: TextStyle(fontSize: 11.0),
                      ),
                      Container(height: 2.0),
                      switchMessageTypeView(
                          contentMessages.contentType, messageBelongType),
                    ],
                  )
                : switchMessageTypeView(
                    contentMessages.contentType, messageBelongType),
          ],
        ),
      ],
    );
  }

  Widget switchMessageTypeView(
      String messageType, MessageBelongType belongType) {
    Widget finalView;
    Map<String, dynamic> content = convert.jsonDecode(contentMessages.content);
    switch (messageType) {
      case "TEXT":
        {
          finalView = _textMessageView(content['text'], belongType);
        }
        break;
      case "IMAGE":
        {
          finalView = ImageMessageWidget(content['img_url'], belongType);
        }
        break;
      case "VIDEO":
        {
          finalView = VideoMessageWidget(content['video_url'], belongType);
        }
        break;
      case "VOICE":
        {
          finalView = VoiceMessageWidget(content['voice_url'], belongType);
        }
        break;
      case "FILE":
        {
          finalView = FileMessageWidget(belongType, content);
        }
        break;
      case "URL":
        {
          finalView = _textMessageView(content['text'], belongType);
        }
        break;
      // case "CARD":
      //   {
      //     finalView = CardMessageWidget(belongType, content);
      //   }
      //   break;
      case "GEO":
        {
          finalView =
              LocationMessageWidget(belongType, content, MapOriginType.Share);
        }
        break;
      default:
        {
          finalView = _textMessageView(content['text'], belongType);
        }
        break;
    }
    return finalView;
  }

  Widget _textMessageView(String content, MessageBelongType belongType,
      {int showIconStatus = 0}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        belongType == MessageBelongType.Sender && showIconStatus == 1
            ? Container(
                child: CupertinoActivityIndicator(radius: 7.0),
              )
            : Container(),
        Container(width: 7.0.w),
        Container(
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
          child: Text('$content',
              maxLines: 10,
              softWrap: true,
              style: messageBelongType == MessageBelongType.Receiver
                  ? Flavors.textStyles.chatBubbleReceiverText
                  : Flavors.textStyles.chatBubbleSenderText),
        )
      ],
    );
  }

// CrossAxisAlignment _createTimePosition(MessageBelongType belongType) {
//   if (belongType == MessageBelongType.Receiver) {
//     return CrossAxisAlignment.end;
//   } else {
//     return CrossAxisAlignment.start;
//   }
// }

// Widget _videoLoadView() {
//   return Selector<ChatDetailManager, VideoLoadType>(
//     builder: (BuildContext context, VideoLoadType value, Widget? child) {
//       if (value == VideoLoadType.Loading) {
//         return Container(
//           child: CupertinoActivityIndicator(),
//         );
//       } else if (value == VideoLoadType.Fail) {
//         return Container(
//           child: CircleAvatar(
//             backgroundColor: Colors.pink,
//             maxRadius: 10,
//             child: Center(
//               child: Icon(
//                 Icons.clear,
//                 color: Colors.white,
//                 size: 15,
//               ),
//             ),
//           ),
//         );
//       } else {
//         return Container();
//       }
//     },
//     selector: (BuildContext context, ChatDetailManager chatDetailManager) {
//       return chatDetailManager.videoLoadType;
//     },
//     shouldRebuild: (pre, next) => (pre != next),
//   );
// }
}
