import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/config.dart';
import 'package:hatchery_im/manager/chat_manager/chatHomeManager.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:convert' as convert;
import '../../utils.dart';
import '../aboutAvatar.dart';

class ChatUsersListItem extends StatelessWidget {
  final Session chatSession;
  ChatUsersListItem({required this.chatSession});
  final manager = App.manager<ChatHomeManager>();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> content;
    String? finalContent;
    print("DEBUG=> chatSession chatSession $chatSession");
    if (chatSession.type == 0) {
      //会话类型，0表示单聊，1表示群聊
      if (chatSession.lastChatMessage != null) {
        finalContent =
            convert.jsonDecode(chatSession.lastChatMessage!.content)["text"];
      }
    } else {
      if (chatSession.lastGroupChatMessage != null) {
        finalContent = convert
            .jsonDecode(chatSession.lastGroupChatMessage!.content)["text"];
      }
    }
    return GestureDetector(
        onTap: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return ChatDetailPage(manager.friendsList[0]);
          // }));
        },
        child: Slidable(
          actionPane: SlidableScrollActionPane(),
          actionExtentRatio: 0.25,
          secondaryActions:
              manager.slideAction.map((e) => slideActionModel(e)).toList(),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
            child: ListTile(
              dense: true,
              leading: netWorkAvatar(
                widget.image!,
                25.0,
              ),
              title: Text(widget.text!),
              subtitle: Text(
                widget.secondaryText!,
                style: Flavors.textStyles.groupMembersNumberText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                checkMessageTime(widget.time!),
                style: TextStyle(
                    fontSize: 12.0,
                    color: widget.isMessageRead!
                        ? Colors.pink
                        : Colors.grey.shade500),
                maxLines: 1,
              ),
            ),
          ),
        ));
  }

  Widget slideActionModel(SlideActionInfo slideActionInfo) {
    return IconSlideAction(
      iconWidget: Container(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text('${slideActionInfo.label}',
              style: Flavors.textStyles.chatHomeSlideText)),
      color: slideActionInfo.iconColor,
      icon: slideActionInfo.icon,
      onTap: () => slideActionInfo.onTap,
    );
  }
}
