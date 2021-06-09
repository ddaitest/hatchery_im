import 'package:hatchery_im/busniess/models/chat_message.dart';
import 'package:hatchery_im/busniess/chat_detail/chat_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatBubble extends StatefulWidget {
  final ChatMessage? chatMessage;
  ChatBubble({@required this.chatMessage});
  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: _chatBubbleView(
            'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3436121203,3749922833&fm=26&gp=0.jpg')

        // Align(
        //   alignment: (widget.chatMessage!.type == MessageType.Receiver
        //       ? Alignment.topLeft
        //       : Alignment.topRight),
        //   child: Container(
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(30),
        //       color: (widget.chatMessage!.type == MessageType.Receiver
        //           ? Colors.white
        //           : Colors.grey.shade300),
        //     ),
        //     padding: EdgeInsets.all(16),
        //     child: Text(widget.chatMessage!.message!),
        //   ),
        // ),
        );
  }

  Widget _chatBubbleView(String? avatarUrl) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      textDirection: widget.chatMessage!.type == MessageType.Receiver
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
        SizedBox(width: 5.0.w),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: widget.chatMessage!.type == MessageType.Receiver
                ? Colors.white
                : Colors.grey.shade300,
          ),
          padding: EdgeInsets.all(16),
          child: Text(widget.chatMessage!.message!),
        )
      ],
    );
  }
}
