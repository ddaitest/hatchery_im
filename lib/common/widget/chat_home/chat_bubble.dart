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
            borderRadius: BorderRadius.circular(10),
            color: widget.chatMessage!.type == MessageType.Receiver
                ? Colors.white
                : Flavors.colorInfo.mainColor,
          ),
          padding: EdgeInsets.all(10),
          child: Container(
            width: Flavors.sizesInfo.screenWidth - 100.0.w,
            child: Text(
                '《金瓶梅》书名由书中三个女主人公潘金莲、李瓶儿、庞春梅名字中各取一字合成。小说题材由《水浒传》中武松杀嫂一段演化而来，通过对兼有官僚、恶霸、富商三种身份的市侩势力代表人物西门庆及其家庭罪恶生活的描述，再现了当时社会民间生活的面貌，描绘了一个上至朝廷擅权专政的太师，下至地方官僚恶霸乃至市井地痞、流氓、帮闲所构成的鬼蜮世界，揭露了明代中叶社会的黑暗和腐败，具有深刻的认识价值。',
                maxLines: 10,
                softWrap: true,
                style: widget.chatMessage!.type == MessageType.Receiver
                    ? Flavors.textStyles.chatBubbleReceiverText
                    : Flavors.textStyles.chatBubbleSenderText),
          ),
        )
      ],
    );
  }
}
