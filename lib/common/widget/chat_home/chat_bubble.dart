import 'package:hatchery_im/busniess/models/chat_message.dart';
import 'package:hatchery_im/busniess/chat_detail/chat_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/utils.dart';

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
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          children: [
            Container(
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
                    style:
                        widget.messageBelongType == MessageBelongType.Receiver
                            ? Flavors.textStyles.chatBubbleReceiverText
                            : Flavors.textStyles.chatBubbleSenderText),
              ),
            ),
            SizedBox(height: 5.0.h),
            Text(
                // '${checkMessageTime(widget.friendsHistoryMessages.createTime)}',
                '${widget.friendsHistoryMessages.createTime}',
                maxLines: 10,
                softWrap: true,
                style: Flavors.textStyles.chatBubbleTimeText),
          ],
        ),
      ],
    );
  }
}
