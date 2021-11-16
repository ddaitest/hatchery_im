import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/config.dart';
import 'package:hatchery_im/manager/chat_manager/chatHomeManager.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hatchery_im/store/LocalStore.dart';
import 'dart:convert' as convert;
import '../../../routers.dart';
import '../../utils.dart';
import '../aboutAvatar.dart';

class ChatUsersListItem extends StatelessWidget {
  final Session chatSession;
  ChatUsersListItem({required this.chatSession});
  final manager = App.manager<ChatHomeManager>();

  @override
  Widget build(BuildContext context) {
    List<SlideActionInfo> slideAction = [
      SlideActionInfo('置顶', Icons.upload_sharp, Flavors.colorInfo.mainColor),
      SlideActionInfo(
          '不提醒', Icons.notifications_off, Flavors.colorInfo.blueGrey),
      SlideActionInfo('删除', Icons.delete, Colors.red,
          onTap: () => LocalStore.deleteSession(chatSession.otherID)),
    ];
    String? _content;
    int _time = chatSession.updateTime;
    if (chatSession.type == 0) {
      //会话类型，0表示单聊，1表示群聊
      _content = chatHomeSubtitleSet(chatSession.lastChatMessage!);
    } else {
      _content = chatHomeSubtitleSet(chatSession.lastGroupChatMessage!);
    }
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: slideAction.map((e) => slideActionModel(e)).toList(),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: ListTile(
          onTap: () => Routers.navigateTo("/chat_detail",
              arg: chatSession.type == 0
                  ? {
                      "chatType": "CHAT",
                      "nickName": chatSession.title,
                      "friendId": chatSession.otherID
                    }
                  : {
                      "chatType": "GROUP",
                      "groupId": chatSession.otherID,
                      "groupName": chatSession.title,
                      "groupIcon": chatSession.icon
                    }),
          dense: false,
          visualDensity: VisualDensity.comfortable,
          leading: netWorkAvatar(chatSession.icon, 25.0,
              avatarType: chatSession.type != 0 ? "groupAvatar" : "avatar"),
          title: Text(chatSession.title),
          subtitle: Container(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              _content!,
              style: Flavors.textStyles.groupMembersNumberText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          trailing: Text(
            "${checkMessageTime(_time).toString().contains("-") ? checkMessageTime(_time).toString().split(" ")[0] : checkMessageTime(_time)}",
            style: TextStyle(fontSize: 12.0, color: Colors.grey.shade500),
            maxLines: 1,
          ),
        ),
      ),
    );
  }

  Widget slideActionModel(SlideActionInfo slideActionInfo) {
    return IconSlideAction(
      iconWidget: Container(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text('${slideActionInfo.label}',
              style: Flavors.textStyles.chatHomeSlideText)),
      color: slideActionInfo.iconColor,
      icon: slideActionInfo.icon,
      foregroundColor: Colors.white,
      onTap: () => slideActionInfo.onTap,
    );
  }
}
