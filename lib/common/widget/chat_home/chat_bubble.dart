import 'dart:convert';

import 'package:hatchery_im/api/engine/entity.dart';
import 'dart:convert' as convert;
import 'package:hatchery_im/business/chat_detail/chat_detail_page.dart';
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

class ChatBubble extends StatelessWidget {
  final String userID;
  final String avatarPicUrl;
  final MessageBelongType messageBelongType;
  final Message contentMessages;

  ChatBubble(
      {required this.userID,
      required this.avatarPicUrl,
      required this.messageBelongType,
      required this.contentMessages});

  final manager = App.manager<ChatDetailManager>();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: _chatBubbleView('${_getAvatarPicUrl()}'));
  }

  String _getAvatarPicUrl() {
    if (avatarPicUrl == "") {
      if (contentMessages.sender == manager.myProfileData!.userID) {
        return manager.myProfileData!.icon!;
      } else {
        return contentMessages.icon;
      }
    }
    {
      return avatarPicUrl;
    }
  }

  Widget _chatBubbleView(String? avatarUrl) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text('${checkMessageTime(contentMessages.createTime)}',
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
                  ? Routers.navigateTo('/friend_profile', arg: userID)
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
            switchMessageTypeView(
                contentMessages.contentType, messageBelongType),
            // SizedBox(width: 15.0.w),
            // contentMessages.contentType == "VIDEO"
            //     ? _videoLoadView()
            //     : Container()
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
          //TODO
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

  Widget _textMessageView(String content, MessageBelongType belongType) {
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
      child: Text('$content',
          maxLines: 10,
          softWrap: true,
          style: messageBelongType == MessageBelongType.Receiver
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
