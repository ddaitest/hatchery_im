import 'package:hatchery_im/busniess/models/chat_message.dart';
import 'package:hatchery_im/busniess/chat_detail/chat_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/common/widget/imageDetail.dart';

class ChatBubble extends StatefulWidget {
  final String avatarPicUrl;
  final MessageBelongType messageBelongType;
  final FriendsHistoryMessages friendsHistoryMessages;
  ChatBubble(
      {required this.avatarPicUrl,
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      textDirection: widget.messageBelongType == MessageBelongType.Receiver
          ? TextDirection.ltr
          : TextDirection.rtl,
      children: [
        CachedNetworkImage(
            imageUrl: avatarUrl ??
                'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3436121203,3749922833&fm=26&gp=0.jpg',
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
          crossAxisAlignment:
              widget.messageBelongType == MessageBelongType.Receiver
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
          children: [
            switchMessageTypeView(widget.friendsHistoryMessages.contentType),
            SizedBox(height: 5.0.h),
            Text(
                '${checkMessageTime(widget.friendsHistoryMessages.createTime)}',
                // '${widget.friendsHistoryMessages.createTime}',
                maxLines: 10,
                softWrap: true,
                style: Flavors.textStyles.chatBubbleTimeText),
          ],
        ),
      ],
    );
  }

  Widget switchMessageTypeView(String messageType) {
    Widget finalView;
    switch (messageType) {
      case "TEXT":
        {
          // finalView = _imageMessageView();
          // finalView = _textMessageView();
          finalView = _voiceMessageView();
        }
        break;
      case "IMAGE":
        {
          finalView = _imageMessageView();
        }
        break;
      case "VIDEO":
        {
          finalView = _textMessageView();
        }
        break;
      case "VOICE":
        {
          finalView = _voiceMessageView();
        }
        break;
      case "FILE":
        {
          finalView = _textMessageView();
        }
        break;
      case "URL":
        {
          finalView = _textMessageView();
        }
        break;
      case "CARD":
        {
          finalView = _textMessageView();
        }
        break;
      case "STICKER":
        {
          finalView = _textMessageView();
        }
        break;
      default:
        {
          finalView = _textMessageView();
        }
        break;
    }
    return finalView;
  }

  Widget _textMessageView() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: widget.messageBelongType == MessageBelongType.Receiver
            ? Colors.white
            : Flavors.colorInfo.mainColor,
      ),
      padding: EdgeInsets.all(10),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: Flavors.sizesInfo.screenWidth - 100.0.w,
        ),
        child: Text('${widget.friendsHistoryMessages.content}',
            maxLines: 10,
            softWrap: true,
            style: widget.messageBelongType == MessageBelongType.Receiver
                ? Flavors.textStyles.chatBubbleReceiverText
                : Flavors.textStyles.chatBubbleSenderText),
      ),
    );
  }

  Widget _imageMessageView() {
    return CachedNetworkImage(
        width: 130.0.w,
        fit: BoxFit.cover,
        imageUrl:
            'https://img0.baidu.com/it/u=2407531684,1522315943&fm=11&fmt=auto&gp=0.jpg',
        // imageUrl: widget.friendsHistoryMessages.content,
        placeholder: (context, url) => Container(
              width: 150.0.w,
              height: 100.0.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Flavors.colorInfo.mainBackGroundColor,
              ),
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            ),
        errorWidget: (context, url, error) => Container(
              width: 150.0.w,
              height: 100.0.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Flavors.colorInfo.mainBackGroundColor,
              ),
              child: Center(
                child: Icon(Icons.image_not_supported_outlined, size: 40),
              ),
            ),
        imageBuilder: (context, imageProvider) {
          return GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ImageDetailViewPage(image: imageProvider))),
            child: Container(
              constraints:
                  BoxConstraints(maxWidth: 130.0.w, maxHeight: 180.0.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
          );
        });
  }

  Widget _voiceMessageView() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: widget.messageBelongType == MessageBelongType.Receiver
            ? Colors.white
            : Flavors.colorInfo.mainColor,
      ),
      padding: EdgeInsets.all(10),
      child: Container(
        height: 20.0.h,
        width: 200.0.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('01:35', style: Flavors.textStyles.chatBubbleSenderText),
            Container(
              height: 5.0.h,
              width: 120.0.w,
              color: Flavors.colorInfo.mainBackGroundColor,
            ),
            Icon(Icons.play_circle_outline,
                color: Flavors.colorInfo.mainBackGroundColor)
          ],
        ),
      ),
    );
  }
}
